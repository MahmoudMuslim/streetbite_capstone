import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:streetbite_capstone/core/error/either.dart';
import 'package:streetbite_capstone/core/error/failures.dart';
import 'package:streetbite_capstone/domain/entities/user_entity.dart';
import 'package:streetbite_capstone/domain/repositories/auth_repository.dart';
import 'package:streetbite_capstone/domain/usecases/get_biometric_sign_in.dart';
import 'package:streetbite_capstone/domain/usecases/login_user.dart';
import 'package:streetbite_capstone/domain/usecases/logout_user.dart';
import 'package:streetbite_capstone/domain/usecases/restore_session.dart';
import 'package:streetbite_capstone/domain/usecases/signup_user.dart';
import 'package:streetbite_capstone/presentation/blocs/auth/auth_cubit.dart';
import 'package:streetbite_capstone/presentation/blocs/auth/auth_state.dart';

import '../helpers/test_fixtures.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthRepository repository;
  late AuthCubit cubit;

  /// Builds a cubit for a device that has (or has not) opted in to biometric
  /// sign-in. Each test stubs `restoreSession()` itself, since the session
  /// verdict is what the gate reacts to.
  void setUpCubit({required bool optIn}) {
    repository = MockAuthRepository();
    when(() => repository.biometricSignInEnabled).thenReturn(optIn);
    cubit = AuthCubit(
      restoreSession: RestoreSession(repository),
      loginUser: LoginUser(repository),
      signUpUser: SignUpUser(repository),
      logoutUser: LogoutUser(repository),
      biometricSignIn: GetBiometricSignIn(repository),
    );
  }

  setUp(() => setUpCubit(optIn: false));

  group('biometric sign-in gate', () {
    test(
      'an opted-in device holds a restored session behind the scan',
      () async {
        final user = TestFixtures.user();
        setUpCubit(optIn: true);
        when(() => repository.restoreSession())
            .thenAnswer((_) async => Right<Failure, UserEntity?>(user));

        await cubit.restore();

        final state = cubit.state;
        expect(state, isA<AuthBiometricGate>());
        expect((state as AuthBiometricGate).user, user);
      },
    );

    test('without the opt-in the same session signs straight in', () async {
      final user = TestFixtures.user();
      when(() => repository.restoreSession())
          .thenAnswer((_) async => Right<Failure, UserEntity?>(user));

      await cubit.restore();

      expect(cubit.state, AuthAuthenticated(user));
    });

    test('a passed scan turns the gate into a session', () async {
      final user = TestFixtures.user();
      setUpCubit(optIn: true);
      when(() => repository.restoreSession())
          .thenAnswer((_) async => Right<Failure, UserEntity?>(user));
      await cubit.restore();

      cubit.confirmBiometricSignIn();

      expect(cubit.state, AuthAuthenticated(user));
    });

    test('declining the scan shows the password form without signing out', () async {
      setUpCubit(optIn: true);
      when(() => repository.restoreSession()).thenAnswer(
        (_) async => Right<Failure, UserEntity?>(TestFixtures.user()),
      );
      await cubit.restore();

      cubit.fallBackToPassword();

      // The whole point of the fallback: the session survives, so the user can
      // still sign in normally instead of paying for one mis-tap with a
      // full re-login.
      expect(cubit.state, const AuthUnauthenticated());
      verifyNever(() => repository.logout());
    });

    test('a confirm outside the gate changes nothing', () {
      cubit.fallBackToPassword();
      final before = cubit.state;

      cubit.confirmBiometricSignIn();

      expect(cubit.state, before);
    });

    test('no session stays signed out even with the opt-in on', () async {
      setUpCubit(optIn: true);
      when(() => repository.restoreSession())
          .thenAnswer((_) async => const Right<Failure, UserEntity?>(null));

      await cubit.restore();

      expect(cubit.state, const AuthUnauthenticated());
    });

    test('a failed restore lands on the password form', () async {
      setUpCubit(optIn: true);
      when(() => repository.restoreSession()).thenAnswer(
        (_) async => const Left<Failure, UserEntity?>(CacheFailure()),
      );

      await cubit.restore();

      expect(cubit.state, const AuthUnauthenticated());
    });
  });

  tearDown(() async {
    if (!cubit.isClosed) await cubit.close();
  });
}
