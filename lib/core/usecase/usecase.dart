/// Base type for application use cases. Implementations throw [Failure] on
/// error, which the presentation layer captures via AsyncValue.guard.
abstract class UseCase<Result, Params> {
  Future<Result> call(Params params);
}

/// Marker for use cases that take no parameters.
class NoParams {
  const NoParams();
}
