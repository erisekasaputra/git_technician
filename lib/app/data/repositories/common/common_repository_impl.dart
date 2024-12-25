import 'package:santai_technician/app/data/datasources/common/common_remote_data_source.dart';
import 'package:santai_technician/app/data/models/common/common_url_image_public_res.dart';
import 'package:santai_technician/app/domain/repository/common/common_repository.dart';

class CommonRepositoryImpl implements CommonRepository {
  final CommonRemoteDataSource remoteDataSource;

  CommonRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CommonUrlImagePublicResModel> getUrlImagePublic() async {
    try {
      final response = await remoteDataSource.getUrlImagePublic();
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
