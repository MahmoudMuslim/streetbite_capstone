import 'package:equatable/equatable.dart';

/// Base contract for every "do one thing" asynchronous use case.
///
/// A use case is the *only* entry point the presentation layer has into the
/// domain layer — BLoCs/Cubits never talk to a repository directly. Keeping
/// [call] abstract makes each use case trivially mockable in unit tests.
///
/// [T] is the **resolved** return type. Fallible use cases declare
/// `UseCase<Either<Failure, X>, P>`, which is what forces every caller to
/// handle the failure branch.
abstract class UseCase<T, P> {
  Future<T> call(P params);
}

/// Base contract for use cases that are pure and synchronous.
///
/// The cart and the totals are client-side computations, so wrapping them in a
/// `Future` would only add microtask hops. Keeping them synchronous also means
/// `CartBloc` can emit the next state inside the same event handler, with no
/// intermediate "loading" frame that the user could see.
abstract class SyncUseCase<T, P> {
  T call(P params);
}

/// Base class for use-case parameter objects.
///
/// Extending [Equatable] keeps Bloc state comparison cheap even when a use case
/// carries a parameter bag.
abstract class Params extends Equatable {
  const Params();

  @override
  List<Object?> get props => const [];
}

/// Parameter object for use cases that take no arguments.
class NoParams extends Params {
  const NoParams();

  @override
  List<Object?> get props => const [];
}
