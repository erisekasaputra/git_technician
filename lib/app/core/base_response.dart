class BaseResponse<T> {
  final bool isSuccess;
  final T data;
  final String message;
  final String responseStatus;
  final List<dynamic> errors;
  final List<dynamic> links;
  final dynamic next;

  BaseResponse({
    required this.isSuccess,
    required this.data,
    required this.message,
    required this.responseStatus,
    required this.errors,
    required this.links,
    this.next,
  });
}
