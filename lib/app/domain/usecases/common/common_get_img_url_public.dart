import 'package:santai_technician/app/domain/entities/common/common_url_image_public_res.dart';
import 'package:santai_technician/app/domain/repository/common/common_repository.dart';

class CommonGetImgUrlPublic {
  final CommonRepository repository;

  CommonGetImgUrlPublic(this.repository);

  Future<CommonUrlImagePublicRes> call() async {
    try {
      return await repository.getUrlImagePublic();
    } catch (e) {
      rethrow;
    }
  }
}
