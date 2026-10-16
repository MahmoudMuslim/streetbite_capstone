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
import 'package:streetbite_capstone/domain/usecases/login_user.dart';
import 'package:streetbite_capstone/domain/usecases/logout_user.dart';
import 'package:streetbite_capstone/domain/usecases/restore_session.dart';
import 'package:streetbite_capstone/domain/usecases/signup_user.dart';
import 'package:streetbite_capstone/l10n/generated/app_localizations.dart';
import 'package:streetbite_capstone/presentation/blocs/auth/auth_cubit.dart';
import 'package:streetbite_capstone/presentation/blocs/auth/auth_state.dart';
import 'package:streetbite_capstone/presentation/blocs/locale/locale_cubit.dart';
import 'package:streetbite_capstone/presentation/blocs/theme/theme_cubit.dart';
import 'package:streetbite_capstone/presentation/screens/auth/login_screen.dart';

import '../helpers/fake_biometric_service.dart';

/// Captured by [pumpLogin] so a test can assert on the final state instead of
/// only on what the UI painted.
AuthCubit? lastAuthCubit;

class MockAuthRepository extends Mock implements AuthRepository {}

class FakeLoginParams extends Fake implements LoginParams {}

class FakeSignUpParams extends Fake implements SignUpParams {}

late MockAuthRepository repository;

AuthCubit buildCubit() => AuthCubit(
  restoreSession: RestoreSession(repository),
  loginUser: LoginUser(repository),
  signUpUser: SignUpUser(repository),
  logoutUser: LogoutUser(repository),
);

/// Sentinel passed to [pumpLogin] to opt into the production behaviour where
/// the locale comes from `LocaleCubit` (required for the toggle test).
const Locale _useCubitLocale = Locale('__cubit__');

void main() {
  // `shared_preferences` needs an in-memory store before anything reads the
  // cache, otherwise the platform channel never answers and the test hangs.
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, Object>{});

  setUpAll(() {
    registerFallbackValue(FakeLoginParams());
    registerFallbackValue(FakeSignUpParams());
    // `local_auth` has no platform channel in the test runner.
    if (!GetIt.I.isRegistered<BiometricService>()) {
      GetIt.I.registerSingleton<BiometricService>(FakeBiometricService());
    }
  });

  setUp(() {
    repository = MockAuthRepository();
    when(
      () => repository.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer(
      (_) async => const Left(AuthFailure('authErrorWrongPassword')),
    );
  });

  /// Pumps the real [LoginScreen] inside a harness that mirrors production:
  /// the three global cubits it depends on, the app theme, the localisations,
  /// and a stub route so a successful login does not explode.
  Future<void> pumpLogin(
    WidgetTester tester, {
    Locale locale = const Locale('en'),
  }) async {
    final themeCubit = ThemeCubit(await SharedPreferences.getInstance());
    final localeCubit = LocaleCubit(await SharedPreferences.getInstance());
    final authCubit = buildCubit();
    lastAuthCubit = authCubit;

    addTearDown(() async {
      await themeCubit.close();
      await localeCubit.close();
      await authCubit.close();
    });

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>.value(value: themeCubit),
          BlocProvider<LocaleCubit>.value(value: localeCubit),
          BlocProvider<AuthCubit>.value(value: authCubit),
        ],
        child: Builder(
          // Mirrors `StreetBiteApp`: the MaterialApp reads the locale from the
          // cubit, which is exactly what makes the EN/AR toggle work at runtime.
          builder: (context) => MaterialApp(
            theme: AppTheme.light,
            locale: locale == _useCubitLocale
                ? context.watch<LocaleCubit>().state.locale
                : locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            onGenerateRoute: (settings) => MaterialPageRoute<dynamic>(
              settings: settings,
              builder: (_) =>
                  Scaffold(body: Center(child: Text('route:${settings.name}'))),
            ),
            home: const LoginScreen(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Types a valid credential pair into the form.
  ///
  /// The screen deliberately does **not** pre-fill anything — a login screen
  /// that quietly fills in a password is a security smell, and it also made
  /// the empty-form validation untestable. Every test therefore types what it
  /// intends to submit, which is what a real user does.
  Future<void> fillCredentials(
    WidgetTester tester, {
    String email = 'yasmine@streetbite.app',
    String password = 'StreetBite123',
  }) async {
    await tester.enterText(
      find.byKey(const ValueKey('login_email_field')),
      email,
    );
    await tester.enterText(
      find.byKey(const ValueKey('login_password_field')),
      password,
    );
    await tester.pump();
  }

  testWidgets('starts with an empty form', (tester) async {
    await pumpLogin(tester);

    // Guards the behaviour above: if someone re-adds a pre-fill, this fails
    // loudly instead of quietly invalidating the validation tests.
    expect(find.text('yasmine@streetbite.app'), findsNothing);
  });

  testWidgets('renders the email field, password field and both actions', (
    tester,
  ) async {
    await pumpLogin(tester);

    expect(find.byKey(const ValueKey('login_email_field')), findsOneWidget);
    expect(find.byKey(const ValueKey('login_password_field')), findsOneWidget);
    expect(find.byKey(const ValueKey('login_button')), findsOneWidget);
    expect(find.byKey(const ValueKey('go_to_sign_up_button')), findsOneWidget);
    expect(find.byKey(const ValueKey('theme_toggle_button')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('language_toggle_button')),
      findsOneWidget,
    );
  });

  testWidgets('shows English copy by default', (tester) async {
    await pumpLogin(tester);

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Log In'), findsOneWidget);
    expect(find.textContaining('Do'), findsWidgets);
  });

  testWidgets('renders the whole form in Arabic', (tester) async {
    await pumpLogin(tester, locale: const Locale('ar'));

    expect(find.text('أهلاً بعودتك'), findsOneWidget);
    expect(find.text('تسجيل الدخول'), findsOneWidget);
    expect(find.text('ليس لديك حساب؟'), findsOneWidget);
  });

  testWidgets('the language toggle switches the copy at runtime', (
    tester,
  ) async {
    await pumpLogin(tester, locale: _useCubitLocale);
    expect(find.text('Welcome back'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('language_toggle_button')));
    await tester.pumpAndSettle();

    expect(find.text('أهلاً بعودتك'), findsOneWidget);
    expect(find.text('Welcome back'), findsNothing);
  });

  testWidgets('rejects a password shorter than six characters', (tester) async {
    await pumpLogin(tester);

    await tester.enterText(
      find.byKey(const ValueKey('login_password_field')),
      '123',
    );
    await tester.tap(find.byKey(const ValueKey('login_button')));
    await tester.pumpAndSettle();

    expect(
      find.text('Password must be at least 6 characters.'),
      findsOneWidget,
    );
    verifyNever(
      () => repository.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    );
  });

  testWidgets('rejects a malformed e-mail address', (tester) async {
    await pumpLogin(tester);

    await tester.enterText(
      find.byKey(const ValueKey('login_email_field')),
      'not-an-email',
    );
    await tester.enterText(
      find.byKey(const ValueKey('login_password_field')),
      'StreetBite123',
    );
    await tester.tap(find.byKey(const ValueKey('login_button')));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a valid email address.'), findsOneWidget);
  });

  testWidgets('surfaces the Firebase rejection as a friendly SnackBar', (
    tester,
  ) async {
    await pumpLogin(tester);

    await fillCredentials(tester);
    await tester.tap(find.byKey(const ValueKey('login_button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byKey(const ValueKey('login_error_snackbar')), findsOneWidget);
    expect(find.text('Incorrect email or password.'), findsOneWidget);
  });

  testWidgets('shows the Arabic SnackBar when the app is in Arabic', (
    tester,
  ) async {
    await pumpLogin(tester, locale: const Locale('ar'));

    await fillCredentials(tester);
    await tester.tap(find.byKey(const ValueKey('login_button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(
      find.text('البريد الإلكتروني أو كلمة المرور غير صحيحة.'),
      findsOneWidget,
    );
  });

  testWidgets('valid credentials emit AuthAuthenticated and navigate', (
    tester,
  ) async {
    when(
      () => repository.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer(
      (_) async => const Right<Failure, UserEntity>(
        UserEntity(uid: 'u1', email: 'yasmine@streetbite.app'),
      ),
    );

    await pumpLogin(tester);

    await fillCredentials(tester);
    await tester.tap(find.byKey(const ValueKey('login_button')));
    await tester.pumpAndSettle();

    expect(lastAuthCubit!.state, isA<AuthAuthenticated>());
    expect(find.text('route:/home'), findsOneWidget);
  });
}
