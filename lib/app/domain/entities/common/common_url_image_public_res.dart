class CommonUrlImagePublicRes {
  final bool isSuccess;
  final Data data;
  final String message;
  final int responseStatus;
  final List<dynamic> errors;
  final List<dynamic> links;

  CommonUrlImagePublicRes({
    required this.isSuccess,
    required this.data,
    required this.message,
    required this.responseStatus,
    required this.errors,
    required this.links,
  });
}

class Data {
  final String url;

  Data({required this.url});
}
