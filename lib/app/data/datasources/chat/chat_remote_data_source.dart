import 'dart:convert';

import 'package:santai_technician/app/config/api_config.dart';
import 'package:santai_technician/app/data/models/chat/chat_contact.dart';
import 'package:santai_technician/app/data/models/chat/conversation.dart';
import 'package:santai_technician/app/domain/entities/chat/chat_contact.dart';
import 'package:santai_technician/app/exceptions/custom_http_exception.dart';
import 'package:santai_technician/app/services/auth_http_client.dart';
import 'package:santai_technician/app/utils/int_extension_method.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatContact>?> getChatContactsByUserType();
  Future<ConversationResponseModel?> getConversationsByOrderId(
      String orderId, int lastTimestamp, bool forward);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final AuthHttpClient client;
  final String baseUrl;

  ChatRemoteDataSourceImpl({
    required this.client,
    this.baseUrl = ApiConfigChat.baseUrl,
  });

  @override
  Future<List<ChatContact>?> getChatContactsByUserType() async {
    var response = await client.get(
        Uri.parse('$baseUrl/chat/contacts?chatContactUserType=Mechanic'),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode.isHttpResponseNotFound()) {
      return null;
    }
    if (response.statusCode.isHttpResponseInternalServerError()) {
      return null;
    }

    if (response.statusCode.isHttpResponseSuccess()) {
      var responseBody = jsonDecode(response.body);
      var data = ChatContactResponseModel.fromJson(responseBody);
      return data.data;
    }

    final Map<String, dynamic> responseBody = response.body.isNotEmpty
        ? json.decode(response.body)
        : {'message': 'Uknown error has occured during fetch chat contacts'};
    throw CustomHttpException(
        response.statusCode,
        responseBody['message'] ??
            (responseBody['title'] ??
                'Uknown error has occured during fetch chat contacts'));
  }

  @override
  Future<ConversationResponseModel?> getConversationsByOrderId(
      String orderId, int lastTimestamp, bool forward) async {
    var response = await client.get(
        Uri.parse(
            '$baseUrl/chat/conversations?orderId=$orderId&timestamp=$lastTimestamp&forward=$forward'),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode.isHttpResponseSuccess()) {
      return ConversationResponseModel.fromJson(jsonDecode(response.body));
    }

    if (response.statusCode.isHttpResponseNotFound()) {
      return null;
    }

    final Map<String, dynamic> responseBody = response.body.isNotEmpty
        ? json.decode(response.body)
        : {'message': 'Uknown error has occured during fetch conversations'};

    throw CustomHttpException(
        response.statusCode,
        responseBody['message'] ??
            (responseBody['title'] ??
                'Uknown error has occured during fetch chat conversations'));
  }
}
