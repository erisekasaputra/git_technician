import 'package:get/get.dart';
import 'package:santai_technician/app/routes/app_pages.dart';

class PreServiceInspectionController extends GetxController {
  final vehicleInfo = {
    'licencePlate': 'BBC 1234',
    'make': 'Triumph',
    'model': 'Tiger 990',
    'year': '2022',
    'odoMeter': '18,000 KM',
    'insurance': '--',
    'roadtax': '--',
    'chassisNumber': '--',
    'engineNumber': '--',
  }.obs;

  final inspectionScores = {
    '(F)Tyre': 8,
    '(F)Brake': 1,
    '(F)Sprocket': 2,
    'Chain': 2,
    'Bearing': 5,
    'Engine': 8,
    'Lights': 10,
    '(R)Brake': 8,
    '(R)Sprocket': 2,
    '(R)Tyre': 5,
  }.obs;

  final serviceProgresses = <ServiceProgress>[].obs;
  final currentServiceIndex = 0.obs;

  final isInspectionLoading = false.obs;
final isNextLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  final serviceProgress = ServiceProgress(
  steps: [
    ServiceStep(label: 'Order Receive', isCompleted: true),
    ServiceStep(label: 'Pick-Up Parts', isCompleted: false),
    ServiceStep(label: 'Servicing', isCompleted: false),
    ServiceStep(label: 'Complete', isCompleted: false),
  ],
  currentStep: 1,
).obs;

  void updateInspectionScore(String item, int score) {
    inspectionScores[item] = score;
  }

  Future<void> onInspectionPressed() async {
  isInspectionLoading.value = true;
  await Future.delayed(const Duration(seconds: 2)); 
  Get.toNamed(Routes.DETAIL_INSPECTION);
  isInspectionLoading.value = false;
}

Future<void> onNextPressed() async {
  isNextLoading.value = true;
  await Future.delayed(const Duration(seconds: 2)); 
  Get.toNamed(Routes.JOB_CHECKLIST);
  isNextLoading.value = false;
}
}

class ServiceProgress {
  final List<ServiceStep> steps;
  final int currentStep;

  ServiceProgress({required this.steps, required this.currentStep});
}

class ServiceStep {
  final String label;
  final bool isCompleted;

  ServiceStep({required this.label, required this.isCompleted});
}