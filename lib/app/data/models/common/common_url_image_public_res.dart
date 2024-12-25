import 'package:santai_technician/app/domain/entities/common/common_url_image_public_res.dart';

class CommonUrlImagePublicResModel extends CommonUrlImagePublicRes {
  CommonUrlImagePublicResModel({
    required super.isSuccess,
    required DataModel super.data,
    required super.message,
    required super.responseStatus,
    required super.errors,
    required super.links,
  });

  factory CommonUrlImagePublicResModel.fromJson(Map<String, dynamic> json) {
    return CommonUrlImagePublicResModel(
      isSuccess: json['isSuccess'],
      data: DataModel.fromJson(json['data']),
      message: json['message'],
      responseStatus: json['responseStatus'],
      errors: json['errors'],
      links: json['links'],
    );
  }
}

class DataModel extends Data {
  DataModel({required super.url});

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      url: json['url'],
    );
  }
}
