import 'package:santai_technician/app/domain/entities/fleet/fleet_user.dart';

class FleetBaseResponse {
  final bool isSuccess;
  final FleetUser data;
  final String message;
  final String responseStatus;
  final List<dynamic> errors;
  final List<dynamic> links;

  FleetBaseResponse({
    required this.isSuccess,
    required this.data,
    required this.message,
    required this.responseStatus,
    required this.errors,
    required this.links,
  });
}
