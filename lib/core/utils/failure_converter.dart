import '../errors/failures.dart';

String mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return "Server Failure";
    case CacheFailure:
      return "Cache Failure";
    case EmptyFailure:
      return "Empty Failure";

    default:
      return "Unexpected error";
  }
}
