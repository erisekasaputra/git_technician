import 'package:get/get.dart';
import 'package:santai_technician/app/routes/app_pages.dart';

enum ExteriorCondition { none, minor, significant }
enum LightType { highBeam, lowBeam }
enum TailightPosition { left, right, center }

class DetailInspectionController extends GetxController {
  final ratings = <String, RxInt>{
    'exterior': 0.obs,
    'lights': 0.obs,
    'tailight': 0.obs,
  };

  final lightStatus = <LightType, Map<String, bool>>{
    LightType.highBeam: {'working': false, 'notWorking': false}.obs,
    LightType.lowBeam: {'working': false, 'notWorking': false}.obs,
  }.obs;

  final exteriorCondition = <ExteriorCondition, bool>{}.obs;
  final tailightStatus = <TailightPosition, bool>{}.obs;

  final exteriorConditionLabels = ['None', 'Minor', 'Significant'];
  final lightLabels = ['High Beam', 'Low Beam'];
  final tailightLabels = ['Left', 'Right', 'Center'];

  void setStatus<T>(Map<T, bool> statusMap, T key, bool value) {
    statusMap[key] = value;
  }

  bool getStatus<T>(Map<T, bool> statusMap, T key) {
    return statusMap[key] ?? false;
  }

  void setLightStatus(LightType type, String status, bool value) {
    lightStatus[type]?[status] = value;
  }

  bool getLightStatus(LightType type, String status) {
    return lightStatus[type]?[status] ?? false;
  }

  void setRating(String key, int value) {
    ratings[key]?.value = value;
  }

  void setExteriorCondition(String key, bool value) {
    ExteriorCondition condition = ExteriorCondition.values.firstWhere(
      (e) => e.toString().split('.').last == key,
      orElse: () => ExteriorCondition.none,
    );
    exteriorCondition[condition] = value;
  }

  bool getExteriorCondition(String key) {
    ExteriorCondition condition = ExteriorCondition.values.firstWhere(
      (e) => e.toString().split('.').last == key,
      orElse: () => ExteriorCondition.none,
    );
    return exteriorCondition[condition] ?? false;
  }

  void setTailightStatus(String key, bool value) {
    TailightPosition position = TailightPosition.values.firstWhere(
      (e) => e.toString().split('.').last == key,
      orElse: () => TailightPosition.left,
    );
    tailightStatus[position] = value;
  }

  bool getTailightStatus(String key) {
    TailightPosition position = TailightPosition.values.firstWhere(
      (e) => e.toString().split('.').last == key,
      orElse: () => TailightPosition.left,
    );
    return tailightStatus[position] ?? false;
  }

  Future<void> nextPage() async {

    Map<String, dynamic> inspectionData = {
      'ratings': ratings.map((key, value) => MapEntry(key, value.value)),
      'lightStatus': lightStatus.map((key, value) => MapEntry(key.toString(), value)),
      'exteriorCondition': exteriorCondition.map((key, value) => MapEntry(key.toString(), value)),
      'tailightStatus': tailightStatus.map((key, value) => MapEntry(key.toString(), value)),
    };


    print('Inspection Data: $inspectionData');

    await Future.delayed(const Duration(seconds: 2));


    Get.toNamed(Routes.JOB_CHECKLIST); 
  }
}