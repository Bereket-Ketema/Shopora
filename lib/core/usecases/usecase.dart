/// Base class for all use cases
/// [T] is the return type
/// [P] is the parameter type
abstract class UseCase<T, P> {
  Future<T> call(P params);
}

/// Use this when a use case doesn't need parameters
class NoParams {
  const NoParams();
}