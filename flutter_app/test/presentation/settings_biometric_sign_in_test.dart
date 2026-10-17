import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streetbite_capstone/core/theme/app_theme.dart';
import 'package:streetbite_capstone/data/services/biometric_service.dart';
import 'package:streetbite_capstone/domain/repositories/auth_repository.dart';
import 'package:streetbite_capstone/domain/usecases/get_biometric_sign_in.dart';
import 'package:streetbite_capstone/domain/usecases/set_biometric_sign_in.dart';
import 'package:streetbite_capstone/l10n/generated/app_localizations.dart';
import 'package:streetbite_capstone/presentation/blocs/locale/locale_cubit.dart';
import 'package:streetbite_capstone/presentation/blocs/theme/theme_cubit.dart';
import 'package:streetbite_capstone/presentation/screens/settings/settings_screen.dart';

import '../helpers/fake_biometric_service.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

/// Counts scans so a test can tell "the switch never asks" from "the switch
/// asks first".
class CountingBiometricService extends FakeBiometricService {
  CountingBiometricService() : super(available: true);

  int authenticateCalls = 0;

  @override
  Future<BiometricResult> authenticate({required String reason}) async {
    authenticateCalls++;
    return super.authenticate(reason: reason);
  }
}

const Key _switchKey = ValueKey('biometric_sign_in_switch');

late MockAuthRepository repository;
late CountingBiometricService service;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, Object>{});

  setUpAll(() {
    service = CountingBiometricService();
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
    service.authenticateCalls = 0;

    when(() => repository.biometricSignInEnabled).thenReturn(false);
    when(
      () => repository.setBiometricSignInEnabled(
        enabled: any<bool>(named: 'enabled'),
      ),
    ).thenAnswer((_) async {});
  });

  Future<void> pumpSettings(WidgetTester tester) async {
    final themeCubit = ThemeCubit(await SharedPreferences.getInstance());
    final localeCubit = LocaleCubit(await SharedPreferences.getInstance());
    addTearDown(() async {
      await themeCubit.close();
      await localeCubit.close();
    });

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>.value(value: themeCubit),
          BlocProvider<LocaleCubit>.value(value: localeCubit),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          locale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const SettingsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder theSwitch() => find.byKey(_switchKey);

  testWidgets('offers the sign-in opt-in on a device that can scan', (
    tester,
  ) async {
    await pumpSettings(tester);

    expect(theSwitch(), findsOneWidget);
    expect(tester.widget<Switch>(theSwitch()).value, isFalse);
  });

  testWidgets('hides the opt-in when the sensor cannot be used', (
    tester,
  ) async {
    service.available = false;
    await pumpSettings(tester);

    expect(theSwitch(), findsNothing);
  });

  testWidgets('turning it on asks for a scan first, then stores the choice', (
    tester,
  ) async {
    await pumpSettings(tester);

    await tester.ensureVisible(theSwitch());
    await tester.tap(theSwitch());
    await tester.pumpAndSettle();

    expect(service.authenticateCalls, 1);
    verify(() => repository.setBiometricSignInEnabled(enabled: true)).called(1);
    expect(tester.widget<Switch>(theSwitch()).value, isTrue);
  });

  testWidgets('a rejected scan leaves the opt-in off', (tester) async {
    service.result = const BiometricResult.failure();
    await pumpSettings(tester);

    await tester.ensureVisible(theSwitch());
    await tester.tap(theSwitch());
    await tester.pumpAndSettle();

    expect(service.authenticateCalls, 1);
    verifyNever(
      () => repository.setBiometricSignInEnabled(
        enabled: any<bool>(named: 'enabled'),
      ),
    );
    expect(tester.widget<Switch>(theSwitch()).value, isFalse);
  });

  testWidgets('turning it off needs no scan and is stored', (tester) async {
    when(() => repository.biometricSignInEnabled).thenReturn(true);
    await pumpSettings(tester);

    await tester.ensureVisible(theSwitch());
    await tester.tap(theSwitch());
    await tester.pumpAndSettle();

    expect(service.authenticateCalls, 0);
    verify(() => repository.setBiometricSignInEnabled(enabled: false))
        .called(1);
  });
}
