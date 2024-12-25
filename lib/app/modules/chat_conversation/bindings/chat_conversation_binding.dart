import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:santai_technician/app/data/datasources/chat/chat_remote_data_source.dart';
import 'package:santai_technician/app/data/repositories/chat/chat_repository_impl.dart';
import 'package:santai_technician/app/domain/repository/chat/chat_repository.dart';
import 'package:santai_technician/app/domain/usecases/chat/get_chat_conversations.dart';
import 'package:santai_technician/app/services/auth_http_client.dart';
import 'package:santai_technician/app/services/secure_storage_service.dart';

import '../controllers/chat_conversation_controller.dart';

class ChatConversationBinding extends Bindings {
  @override
  void dependencies() {
    Get.create<http.Client>(() => http.Client());
    Get.create<SecureStorageService>(() => SecureStorageService());
    Get.create<AuthHttpClient>(() => AuthHttpClient(
        Get.find<http.Client>(), Get.find<SecureStorageService>()));

    Get.create<ChatRemoteDataSource>(
      () => ChatRemoteDataSourceImpl(client: Get.find<AuthHttpClient>()),
    );

    Get.create<ChatRepository>(
      () => ChatRepositoryImpl(
          remoteDataSource: Get.find<ChatRemoteDataSource>()),
    );

    Get.create(() => GetChatConversationsByOrderId(Get.find<ChatRepository>()));

    Get.put<ChatConversationController>(
      ChatConversationController(
          getChatConversationByOrderId:
              Get.find<GetChatConversationsByOrderId>()),
    );
  }
}
