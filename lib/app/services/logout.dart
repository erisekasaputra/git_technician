import 'package:get/get.dart';
import 'package:santai_technician/app/routes/app_pages.dart';
import 'package:santai_technician/app/services/secure_storage_service.dart';

class Logout extends GetxController {
  final SecureStorageService _secureStorage = SecureStorageService();

  Future<void> doLogout() async {
    try {
      // Hapus semua data terlebih dahulu
      await _secureStorage.deleteSecureData('access_token');
      await _secureStorage.deleteSecureData('refresh_token');
      await _secureStorage.deleteSecureData('user_type');
      await _secureStorage.deleteSecureData('business_code');
      await _secureStorage.deleteSecureData('time_zone');
      await _secureStorage.deleteSecureData('user_name');
      await _secureStorage.deleteSecureData('user_phone_number');
      await _secureStorage.deleteSecureData('user_image_profile_url');
      await _secureStorage.deleteSecureData('user_id');

      // Setelah data berhasil dihapus, navigasi ke halaman login
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      // Tangani jika ada error, misalnya dengan notifikasi
      Get.snackbar('Logout Error', 'Terjadi kesalahan saat logout: $e');
    }
  }
}
