/// Minimal `Either` implementation used across every layer.
///
/// Why not throw?
/// ----------------
/// Exceptions are invisible to the type system: a repository can forget one
/// and the compiler stays quiet, which is exactly how "unhandled exception"
/// bugs reach production. With a sealed result type the *caller is forced* to
/// deal with the failure branch — there is no way to ignore it by accident —
/// and it is why StreetBite can promise that nothing escapes a repository
/// uncaught.
///
/// `L` is the failure type (always a `Failure`) and `R` the success type.
library;

sealed class Either<L, R> {
  const Either();

  const factory Either.left(L value) = Left<L, R>;
  const factory Either.right(R value) = Right<L, R>;

  /// Value when this is a [Right], otherwise `null`.
  R? get valueOrNull => switch (this) {
    Right<L, R>(:final value) => value,
    Left<L, R>() => null,
  };

  /// Failure when this is a [Left], otherwise `null`.
  L? get failureOrNull => switch (this) {
    Right<L, R>() => null,
    Left<L, R>(:final value) => value,
  };

  bool get isRight => this is Right<L, R>;
  bool get isLeft => this is Left<L, R>;

  /// Collapses both branches into one value — the idiomatic way to consume an
  /// `Either` without an `if` in every Cubit.
  T fold<T>(T Function(L failure) onFailure, T Function(R value) onSuccess) =>
      switch (this) {
        Right<L, R>(:final value) => onSuccess(value),
        Left<L, R>(:final value) => onFailure(value),
      };

  /// Transforms the success branch, keeping any failure untouched.
  Either<L, T> map<T>(T Function(R value) transform) => switch (this) {
    Right<L, R>(:final value) => Right<L, T>(transform(value)),
    Left<L, R>(:final value) => Left<L, T>(value),
  };

  /// Runs [action] only on success — used by use cases that also trigger a
  /// cache write after a successful fetch.
  Either<L, R> onRight(void Function(R value) action) {
    if (this case Right<L, R>(:final value)) action(value);
    return this;
  }
}

/// Failure branch.
final class Left<L, R> extends Either<L, R> {
  const Left(this.value);

  final L value;

  @override
  R? get valueOrNull => null;

  @override
  L get failureOrNull => value;
}

/// Success branch.
final class Right<L, R> extends Either<L, R> {
  const Right(this.value);

  final R value;

  @override
  R? get valueOrNull => value;

  @override
  L? get failureOrNull => null;
}
