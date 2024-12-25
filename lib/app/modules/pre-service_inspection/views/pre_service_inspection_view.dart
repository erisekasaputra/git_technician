import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai_technician/app/common/widgets/custom_back_button.dart';
import 'package:santai_technician/app/theme/app_theme.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../controllers/pre_service_inspection_controller.dart';

class PreServiceInspectionView extends GetView<PreServiceInspectionController> {
  const PreServiceInspectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 0, 8),
              child: CustomBackButton(
                onPressed: () => Get.back(),
              ),
            ),
            leadingWidth: 100,
            title: const Text(
              'Service Inspection',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildVehicleInfoCard(context),
                  const SizedBox(height: 20),
                  _buildBasicInspectionSection(context),
                  const SizedBox(height: 20),
                  _buildActionButtons(context),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildVehicleInfoCard(BuildContext context) {
    final Color warning_300 = Theme.of(context).colorScheme.warning_300;
    final Color borderInput_01 = Theme.of(context).colorScheme.borderInput_01;
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderInput_01, width: 1),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.zero,
          bottomRight: Radius.zero,
          bottomLeft: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 16, 8, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Stack(
                    children: [
                      Obx(() {
                        if (controller.commonUrlAssetInternet.value == '' ||
                            controller.fleet.value?.data.imageUrl == null) {
                          return const SizedBox(
                            height: 10,
                          );
                        }

                        return SizedBox(
                          height: 260,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                                bottomLeft: Radius.circular(10),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(
                                    '${controller.commonUrlAssetInternet}${controller.fleet.value?.data.imageUrl}'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      }),
                      Positioned(
                        left: 0,
                        bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: warning_300,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.zero,
                              bottomRight: Radius.zero,
                              bottomLeft: Radius.zero,
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(10, 8, 20, 8),
                            child: Text(
                              // controller.selectedMotorcycle.value,
                              'Motorcycle',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: Obx(
                    () {
                      return ListView(
                        shrinkWrap: true,
                        children: [
                          _buildInfoRow(
                              'Lisence Plate',
                              controller.homeController?.orderData.value?.data
                                      .fleets.first.registrationNumber ??
                                  'NA'),
                          _buildInfoRow(
                              'Make',
                              controller.homeController?.orderData.value?.data
                                      .fleets.first.brand ??
                                  'NA'),
                          _buildInfoRow(
                              'Model',
                              controller.homeController?.orderData.value?.data
                                      .fleets.first.model ??
                                  'NA'),
                          _buildInfoRow(
                              'Year',
                              (controller.fleet.value?.data.yearOfManufacture
                                      .toString()) ??
                                  "N/A"),
                          _buildInfoRow(
                              'Odo Meter',
                              (controller.fleet.value?.data.odometerReading
                                      .toString()) ??
                                  "N/A"),
                          _buildInfoRow(
                              'Insurance',
                              (controller.fleet.value?.data.insuranceNumber
                                      .toString()) ??
                                  "N/A"),
                          _buildInfoRow(
                              'Chassis Number',
                              (controller.fleet.value?.data.chassisNumber
                                      .toString()) ??
                                  "N/A"),
                          _buildInfoRow(
                              'Engine Number',
                              (controller.fleet.value?.data.engineNumber
                                      .toString()) ??
                                  "N/A"),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.black),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineTiles(
      ServiceProgress service, Color primary_300, Color warning_300) {
    return Row(
      children: [
        for (int i = 0; i < service.steps.length; i++)
          Expanded(
            child: TimelineTile(
              axis: TimelineAxis.horizontal,
              alignment: TimelineAlign.center,
              isFirst: i == 0,
              isLast: i == service.steps.length - 1,
              indicatorStyle: IndicatorStyle(
                width: 22,
                color: service.steps[i].isCompleted ? primary_300 : warning_300,
                iconStyle: IconStyle(
                  color: Colors.white,
                  iconData: service.steps[i].isCompleted
                      ? Icons.check_circle_rounded
                      : Icons.circle,
                  fontSize: 13,
                ),
              ),
              beforeLineStyle: LineStyle(
                  color:
                      service.steps[i].isCompleted ? primary_300 : warning_300),
              afterLineStyle: LineStyle(
                  color: i < service.currentStep ? primary_300 : warning_300),
              endChild: Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Text(
                  service.steps[i].label,
                  style: TextStyle(
                    color: service.steps[i].isCompleted
                        ? primary_300
                        : Colors.black,
                    fontWeight: service.steps[i].isCompleted
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBasicInspectionSection(BuildContext context) {
    final Color borderInput_01 = Theme.of(context).colorScheme.borderInput_01;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  'Basic Inspection',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(height: 10),
                Text(
                  'Score from 1 - 10 with 1 require immediate attention & 10 is perfect',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: borderInput_01, width: 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 1, horizontal: 10),
                      child: Obx(
                        () => Column(
                          children: [
                            if (controller.basicInspection1.isNotEmpty)
                              for (var pre in controller.basicInspection1) ...[
                                _buildInspectionItem(pre.description,
                                    pre.parameter, borderInput_01,
                                    isLeftSide: false)
                              ]
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(1),
                child: Image.asset('assets/images/motor.png'),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: borderInput_01, width: 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 1, horizontal: 10),
                      child: Obx(
                        () => Column(
                          children: [
                            if (controller.basicInspection2.isNotEmpty)
                              for (var pre in controller.basicInspection2) ...[
                                _buildInspectionItem(pre.description,
                                    pre.description, borderInput_01,
                                    isLeftSide: true)
                              ]
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInspectionItem(String label, String key, Color borderInput_01,
      {bool isLeftSide = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (isLeftSide) _buildDropdown(key, borderInput_01),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.black),
              overflow: TextOverflow.clip,
              maxLines: 2,
            ),
          ),
          if (!isLeftSide) _buildDropdown(key, borderInput_01),
        ],
      ),
    );
  }

  Widget _buildDropdown(String key, Color borderInput_01) {
    return Obx(() {
      int index = -1;
      int score = 0;
      try {
        index = controller.basicInspectionScores
            .indexWhere((inspection) => inspection.parameter == key);
        score = controller.basicInspectionScores[index].value;
      } catch (_) {}

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          border: Border.all(color: borderInput_01),
          borderRadius: BorderRadius.circular(4),
        ),
        child: DropdownButton<int>(
          value: score,
          items: List.generate(11, (index) {
            return DropdownMenuItem(
              value: index,
              child: Text((index).toString()),
            );
          }),
          onChanged: (value) {
            if (value != null) {
              controller.updateInspectionScore(key, value);
            }
          },
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          underline: const SizedBox(),
          icon: const SizedBox.shrink(),
          isDense: true,
          alignment: AlignmentDirectional.center,
        ),
      );
    });
  }

  Widget _buildActionButtons(BuildContext context) {
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;

    return Row(
      children: [
        // Expanded(
        //   child: Obx(() => Container(
        //         height: 48,
        //         decoration: BoxDecoration(
        //           color: Colors.white,
        //           border: Border.all(color: primary_300),
        //           borderRadius: BorderRadius.circular(15),
        //         ),
        //         child: Material(
        //           color: Colors.transparent,
        //           child: InkWell(
        //             borderRadius: BorderRadius.circular(15),
        //             onTap: controller.isInspectionLoading.value
        //                 ? null
        //                 : controller.onInspectionPressed,
        //             child: Center(
        //               child: controller.isInspectionLoading.value
        //                   ? SizedBox(
        //                       width: 24,
        //                       height: 24,
        //                       child: CircularProgressIndicator(
        //                         valueColor:
        //                             AlwaysStoppedAnimation<Color>(primary_300),
        //                         strokeWidth: 2,
        //                       ),
        //                     )
        //                   : Text(
        //                       'Inspection',
        //                       style: TextStyle(
        //                         color: primary_300,
        //                         fontWeight: FontWeight.bold,
        //                       ),
        //                     ),
        //             ),
        //           ),
        //         ),
        //       )),
        // ),
        // const SizedBox(width: 20),
        Expanded(
          child: Obx(() => Container(
                height: 48,
                decoration: BoxDecoration(
                  color: primary_300,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: controller.isNextLoading.value
                        ? null
                        : controller.onNextPressed,
                    child: Center(
                      child: controller.isNextLoading.value
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Next',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              )),
        ),
      ],
    );
  }
}
