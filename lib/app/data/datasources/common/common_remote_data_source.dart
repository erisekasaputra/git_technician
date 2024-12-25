import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:santai_technician/app/config/api_config.dart';
import 'package:santai_technician/app/data/models/common/common_url_image_public_res.dart';
import 'package:santai_technician/app/exceptions/custom_http_exception.dart';
import 'package:santai_technician/app/utils/http_error_handler.dart';
import 'package:santai_technician/app/utils/int_extension_method.dart';

abstract class CommonRemoteDataSource {
  Future<CommonUrlImagePublicResModel> getUrlImagePublic();
}

class CommonRemoteDataSourceImpl implements CommonRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  CommonRemoteDataSourceImpl({
    required this.client,
    this.baseUrl = ApiConfigUploadImage.baseUrl,
  });

  @override
  Future<CommonUrlImagePublicResModel> getUrlImagePublic() async {
    final url = '$baseUrl/Files/images/public/url';
    final response = await client.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode.isHttpResponseSuccess()) {
      if (response.body.isEmpty) {
        throw CustomHttpException(500, 'Internal server error');
      }
      return CommonUrlImagePublicResModel.fromJson(
        jsonDecode(response.body),
      );
    }

    handleError(response, 'Unable to get image url. Please try again shortly');
    throw Exception();
  }
}
