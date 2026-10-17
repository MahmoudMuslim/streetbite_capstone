import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streetbite_capstone/core/error/either.dart';
import 'package:streetbite_capstone/core/error/failures.dart';
import 'package:streetbite_capstone/core/theme/app_theme.dart';
import 'package:streetbite_capstone/data/services/biometric_service.dart';
import 'package:streetbite_capstone/domain/entities/user_entity.dart';
import 'package:streetbite_capstone/domain/repositories/auth_repository.dart';
import 'package:streetbite_capstone/domain/usecases/get_biometric_sign_in.dart';
import 'package:streetbite_capstone/domain/usecases/login_user.dart';
import 'package:streetbite_capstone/domain/usecases/logout_user.dart';
import 'package:streetbite_capstone/domain/usecases/restore_session.dart';
import 'package:streetbite_capstone/domain/usecases/set_biometric_sign_in.dart';
import 'package:streetbite_capstone/domain/usecases/signup_user.dart';
import 'package:streetbite_capstone/l10n/generated/app_localizations.dart';
import 'package:streetbite_capstone/presentation/blocs/auth/auth_cubit.dart';
import 'package:streetbite_capstone/presentation/blocs/auth/auth_state.dart';
import 'package:streetbite_capstone/presentation/blocs/locale/locale_cubit.dart';
import 'package:streetbite_capstone/presentation/blocs/theme/theme_cubit.dart';
import 'package:streetbite_capstone/presentation/screens/auth/biometric_login_screen.dart';

import '../helpers/fake_biometric_service.dart';
import '../helpers/test_fixtures.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

/// A fake scan that can be held open.
///
/// The real prompt blocks until the owner reacts, and several behaviours here
/// only exist while a scan is *in flight* — so a fake that answers immediately
/// could never exercise them.
class ControllableBiometricService extends FakeBiometricService {
  ControllableBiometricService() : super(available: true);

  Completer<void>? hold;

  @override
  Future<BiometricResult> authenticate({required String reason}) async {
    await hold?.future;
    return result;
  }
}

late MockAuthRepository repository;
late ControllableBiometricService service;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, Object>{});

  setUpAll(() {
    // `local_auth` has no platform channel in the test runner, and the screen
    // resolves the service from GetIt exactly as it does at runtime.
    service = ControllableBiometricService();
    GetIt.I.registerSingleton<BiometricService>(service);
    // Registered once over the reassignable [repository] so every test gets the
    // mock it just built without touching the container again.
    GetIt.I.registerFactory<GetBiometricSignIn>(
      () => GetBiometricSignIn(repository),
    );
    GetIt.I.registerFactory<SetBiometricSignIn>(
      () => SetBiometricSignIn(repository),
    );
  });

  setUp(() {
    repository = MockAuthRepository();
    service.available = true;
    service.result = BiometricResult.success;
    service.hold = null;
  });

  /// Puts the screen on top of a gated session and reports the last route name
  /// the app asked for.
  Future<(AuthCubit, List<String>)> pumpGate(WidgetTester tester) async {
    when(() => repository.biometricSignInEnabled).thenReturn(true);
    when(
      () => repository.restoreSession(),
    ).thenAnswer((_) async => Right<Failure, UserEntity?>(TestFixtures.user()));

    final themeCubit = ThemeCubit(await SharedPreferences.getInstance());
    final localeCubit = LocaleCubit(await SharedPreferences.getInstance());
    final authCubit = AuthCubit(
      restoreSession: RestoreSession(repository),
      loginUser: LoginUser(repository),
      signUpUser: SignUpUser(repository),
      logoutUser: LogoutUser(repository),
      biometricSignIn: GetBiometricSignIn(repository),
    );
    await authCubit.restore();

    final routes = <String>[];
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>.value(value: themeCubit),
          BlocProvider<LocaleCubit>.value(value: localeCubit),
          BlocProvider<AuthCubit>.value(value: authCubit),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          locale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          onGenerateRoute: (settings) {
            routes.add(settings.name ?? '<unknown>');
            return MaterialPageRoute<dynamic>(
              builder: (_) => Text('route:${settings.name}'),
            );
          },
          home: const BiometricLoginScreen(),
        ),
      ),
    );

    addTearDown(() async {
      await themeCubit.close();
      await localeCubit.close();
      if (!authCubit.isClosed) await authCubit.close();
    });

    return (authCubit, routes);
  }

  group('biometric sign-in screen', () {
    testWidgets('a passed scan greets the user by name and opens Home', (
      tester,
    ) async {
      final (cubit, routes) = await pumpGate(tester);
      await tester.pumpAndSettle();

      expect(cubit.state, isA<AuthAuthenticated>());
      expect(routes, contains('/home'));
    });

    testWidgets('a device with no sensor goes straight to the password form', (
      tester,
    ) async {
      service.available = false;
      final (cubit, routes) = await pumpGate(tester);
      await tester.pumpAndSettle();

      expect(cubit.state, const AuthUnauthenticated());
      expect(routes, contains('/login'));
      // The fallback changes the screen, not the session.
      verifyNever(() => repository.logout());
    });

    testWidgets('a rejected scan ends at the password form', (tester) async {
      service.result = const BiometricResult.failure();
      final (_, routes) = await pumpGate(tester);
      await tester.pumpAndSettle();

      expect(routes, contains('/login'));
      verifyNever(() => repository.logout());
    });

    testWidgets('shows whose account is being unlocked while it waits', (
      tester,
    ) async {
      service.hold = Completer<void>();
      await pumpGate(tester);
      await tester.pumpAndSettle();

      expect(find.text('Welcome back, Yasmine'), findsOneWidget);
      expect(find.text('Scan to sign in'), findsOneWidget);
    });

    testWidgets('"Use password instead" leaves the scan behind for good', (
      tester,
    ) async {
      final pending = Completer<void>();
      service.hold = pending;
      final (cubit, routes) = await pumpGate(tester);
      await tester.pump();
      await tester.pump();

      await tester.tap(find.byKey(const ValueKey('use_password_button')));
      await tester.pumpAndSettle();

      expect(cubit.state, const AuthUnauthenticated());
      expect(routes, contains('/login'));

      // The prompt landing after the choice must not undo it.
      pending.complete();
      await tester.pumpAndSettle();

      expect(routes, isNot(contains('/home')));
      verifyNever(() => repository.logout());
    });
  });
}
