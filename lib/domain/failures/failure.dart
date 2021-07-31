abstract class Failure {}

class ServerErrorFailure implements Failure {
  final String? message;

  ServerErrorFailure({this.message});
}

class UnhandledFailure implements Failure {}

class NotFoundFailure implements Failure {}
