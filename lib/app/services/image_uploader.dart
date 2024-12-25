import 'dart:convert';
import 'dart:io';

import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:santai_technician/app/config/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:santai_technician/app/utils/int_extension_method.dart';
import 'package:santai_technician/app/utils/session_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ImageUploaderService extends GetxService {
  final String apiUrlPublic =
      '${ApiConfigUploadImage.baseUrl}/Files/images/public';
  final SessionManager sessionManager = SessionManager();

  Future<String> uploadImage(File imageFile) async {
    try {
      final accessToken =
          await sessionManager.getSessionBy(SessionManagerType.accessToken);

      if (accessToken.isEmpty) {
        throw Exception('Your session is invalid');
      }

      var request = http.MultipartRequest('POST', Uri.parse(apiUrlPublic));

      request.headers['Authorization'] = 'Bearer $accessToken';

      String fileExtension = imageFile.path.split('.').last.toLowerCase();

      String mimeType;
      switch (fileExtension) {
        case 'jpg':
        case 'jpeg':
          mimeType = 'image/jpeg';
          break;
        case 'png':
          mimeType = 'image/png';
          break;
        case 'gif':
          mimeType = 'image/gif';
          break;
        default:
          throw Exception('Unsupported image format');
      }

      request.files.add(await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        contentType: MediaType.parse(mimeType),
      ));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        var jsonResponse = json.decode(response.body);
        return jsonResponse['data']['resourceName'];
      } else {
        throw Exception('Failed to upload image: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  Future<File?> downloadAndSetProfileImage(String imageUrl) async {
    try {
      var uuid = const Uuid().v4();
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode.isHttpResponseSuccess()) {
        final directory = await getApplicationDocumentsDirectory();

        final filePath =
            '${directory.path}/profile_picture_${uuid.replaceAll('-', '_')}.jpg';

        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        return file;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
