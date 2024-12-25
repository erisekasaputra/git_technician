class FleetUser {
  final String? id;
  final String registrationNumber;
  final String vehicleType;
  final String brand;
  final String model;
  final int yearOfManufacture;
  final String chassisNumber;
  final String engineNumber;
  final String insuranceNumber;
  final bool isInsuranceValid;
  final DateTime lastInspectionDateLocal;
  final int odometerReading;
  final String fuelType;
  final String ownerName;
  final String ownerAddress;
  final String usageStatus;
  final String ownershipStatus;
  final String transmissionType;
  final String? imageUrl;

  FleetUser({
    this.id,
    required this.registrationNumber,
    required this.vehicleType,
    required this.brand,
    required this.model,
    required this.yearOfManufacture,
    required this.chassisNumber,
    required this.engineNumber,
    required this.insuranceNumber,
    required this.isInsuranceValid,
    required this.lastInspectionDateLocal,
    required this.odometerReading,
    required this.fuelType,
    required this.ownerName,
    required this.ownerAddress,
    required this.usageStatus,
    required this.ownershipStatus,
    required this.transmissionType,
    this.imageUrl,
  });
}
