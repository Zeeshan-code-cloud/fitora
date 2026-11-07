class Failure {
  String? errorMessage;
  String? errorCode;

  Failure({
    this.errorMessage,
    this.errorCode
});

  @override
  String toString() {
     return "the error is $errorMessage";
  }
}