import 'package:get/get.dart';
import 'package:santai_technician/app/data/datasources/profile/profile_remote_data_source.dart';
import 'package:santai_technician/app/data/repositories/profile/profile_repository_impl.dart';
import 'package:santai_technician/app/domain/repository/profile/profile_repository.dart';
import 'package:santai_technician/app/domain/usecases/profile/get_user_profile.dart';
import 'package:santai_technician/app/services/auth_http_client.dart';
import 'package:santai_technician/app/services/secure_storage_service.dart';
import '../controllers/register_otp_controller.dart';
import 'package:http/http.dart' as http;

import 'package:santai_technician/app/domain/usecases/authentikasi/send_otp.dart';
import 'package:santai_technician/app/domain/usecases/authentikasi/otp_verify_register.dart';

import 'package:santai_technician/app/data/repositories/authentikasi/auth_repository_impl.dart';
import 'package:santai_technician/app/data/datasources/authentikasi/auth_remote_data_source.dart';
import 'package:santai_technician/app/domain/repository/authentikasi/auth_repository.dart';

import 'package:santai_technician/app/domain/usecases/authentikasi/verify_login.dart';

class RegisterOtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.create<SecureStorageService>(() => SecureStorageService());
    Get.create<http.Client>(() => http.Client());
    Get.create<AuthHttpClient>(() => AuthHttpClient(
        Get.find<http.Client>(), Get.find<SecureStorageService>()));

    Get.create<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(client: Get.find<http.Client>()),
    );
    Get.create<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(client: Get.find<AuthHttpClient>()),
    );

    Get.create<AuthRepository>(
      () => AuthRepositoryImpl(
          remoteDataSource: Get.find<AuthRemoteDataSource>()),
    );
    Get.create<ProfileRepository>(
      () => ProfileRepositoryImpl(
          remoteDataSource: Get.find<ProfileRemoteDataSource>()),
    );

    Get.create(() => SendOtp(Get.find<AuthRepository>()));
    Get.create(() => VerifyOtpRegister(Get.find<AuthRepository>()));
    Get.create(() => LoginVerify(Get.find<AuthRepository>()));
    Get.create(() => GetUserProfile(Get.find<ProfileRepository>()));

    Get.put<RegisterOtpController>(
      RegisterOtpController(
          sendOtp: Get.find<SendOtp>(),
          otpRegisterVerify: Get.find<VerifyOtpRegister>(),
          verifyLogin: Get.find<LoginVerify>(),
          getUserProfile: Get.find<GetUserProfile>()),
    );
  }
}
