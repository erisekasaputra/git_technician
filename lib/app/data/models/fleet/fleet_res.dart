import 'package:santai_technician/app/domain/entities/fleet/fleet_base_response.dart';
import 'package:santai_technician/app/domain/entities/fleet/fleet_user.dart';

class FleetUserResponseModel extends FleetBaseResponse {
  FleetUserResponseModel({
    required super.isSuccess,
    required FleetUserDataModel super.data,
    required super.message,
    required super.responseStatus,
    required super.errors,
    required super.links,
  });

  factory FleetUserResponseModel.fromJson(Map<String, dynamic> json) {
    return FleetUserResponseModel(
      isSuccess: json['isSuccess'],
      data: FleetUserDataModel.fromJson(json['data']),
      message: json['message'],
      responseStatus: json['responseStatus'],
      errors: json['errors'],
      links: json['links'],
    );
  }
}

class FleetUserDataModel extends FleetUser {
  FleetUserDataModel({
    required String super.id,
    required super.registrationNumber,
    required super.vehicleType,
    required super.brand,
    required super.model,
    required super.yearOfManufacture,
    required super.chassisNumber,
    required super.engineNumber,
    required super.insuranceNumber,
    required super.isInsuranceValid,
    required super.lastInspectionDateLocal,
    required super.odometerReading,
    required super.fuelType,
    required super.ownerName,
    required super.ownerAddress,
    required super.usageStatus,
    required super.ownershipStatus,
    required super.transmissionType,
    super.imageUrl,
  });

  factory FleetUserDataModel.fromJson(Map<String, dynamic> json) {
    return FleetUserDataModel(
      id: json['id'],
      registrationNumber: json['registrationNumber'],
      vehicleType: json['vehicleType'],
      brand: json['brand'],
      model: json['model'],
      yearOfManufacture: json['yearOfManufacture'],
      chassisNumber: json['chassisNumber'],
      engineNumber: json['engineNumber'],
      insuranceNumber: json['insuranceNumber'],
      isInsuranceValid: json['isInsuranceValid'],
      lastInspectionDateLocal: DateTime.parse(json['lastInspectionDateLocal']),
      odometerReading: json['odometerReading'],
      fuelType: json['fuelType'],
      ownerName: json['ownerName'],
      ownerAddress: json['ownerAddress'],
      usageStatus: json['usageStatus'],
      ownershipStatus: json['ownershipStatus'],
      transmissionType: json['transmissionType'],
      imageUrl: json['imageUrl'],
    );
  }
}
