import 'package:santai_technician/app/domain/entities/common/common_url_image_public_res.dart';
// import 'package:santai/app/domain/entities/fleet/fleet_list_fleet_user_res.dart';

abstract class CommonRepository {
  Future<CommonUrlImagePublicRes> getUrlImagePublic();
  // Future<FleetListFleetUserResponse> getFleetUser();
}
