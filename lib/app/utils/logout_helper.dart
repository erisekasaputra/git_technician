import 'package:santai_technician/app/services/secure_storage_service.dart';

SecureStorageService _secureStorage = SecureStorageService();

Future<void> logoutSecureStorage() async {
  await _secureStorage.deleteSecureData('access_token');
  await _secureStorage.deleteSecureData('refresh_token');
  await _secureStorage.deleteSecureData('user_type');
  await _secureStorage.deleteSecureData('business_code');
  await _secureStorage.deleteSecureData('time_zone');
  await _secureStorage.deleteSecureData('user_name');
  await _secureStorage.deleteSecureData('user_phone_number');
  await _secureStorage.deleteSecureData('user_image_profile_url');
  await _secureStorage.deleteSecureData('user_id');
}
