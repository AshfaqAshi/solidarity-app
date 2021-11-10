
class Result<T>{
  int? errorCode;
  String? message;
  String? userMessage;
  bool success;
  T? value;
  Result(this.value,{this.success=true,this.message,this.userMessage,this.errorCode});
}

class ErrorCodes{
  static const int USER_EXISTS=0;
  static const int NO_USER=1;
  static const int NO_DATA=2;
}