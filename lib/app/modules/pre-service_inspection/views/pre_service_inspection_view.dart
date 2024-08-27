import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai_technician/app/common/widgets/custom_back_button.dart';
import 'package:santai_technician/app/theme/app_theme.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../controllers/pre_service_inspection_controller.dart';

class PreServiceInspectionView extends GetView<PreServiceInspectionController> {
  const PreServiceInspectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(14, 8, 0, 8),
          child: CustomBackButton(
            onPressed: () => Get.back(),
          ),
        ),
        leadingWidth: 60,
        title: const Text(
          'Service Inspection',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
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
              // const SizedBox(height: 20),
              _buildServiceProgress(context),
              const SizedBox(height: 20),
              _buildBasicInspectionSection(context),
              const SizedBox(height: 20),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
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
                      SizedBox(
                        height: 260,
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                              bottomLeft: Radius.circular(10),
                            ),
                            image: DecorationImage(
                              image:
                                  NetworkImage('https://picsum.photos/200/300'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
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
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(''),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.black,
                                  size: 18,
                                ),
                                onPressed: () {},
                              ),
                              const Text(
                                'Edit',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black),
                              ),
                            ],
                          )
                        ],
                      ),
                      _buildInfoRow('Lisence Plate', 'BBC 1234'),
                      _buildInfoRow('Make', 'Triumph'),
                      _buildInfoRow('Model', 'Tiger 990'),
                      _buildInfoRow('Year', '2022'),
                      _buildInfoRow('Odo Meter', '18,000 KM'),
                      _buildInfoRow('Insurance', '--'),
                      _buildInfoRow('Roadtax', '--'),
                      _buildInfoRow('Chassis Number', '--'),
                      _buildInfoRow('Engine Number', '--'),
                    ],
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

Widget _buildServiceProgress(BuildContext context) {
  return Builder(builder: (BuildContext context) {
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;
    final Color warning_300 = Theme.of(context).colorScheme.warning_300;
    return SizedBox(
      height: 100,
      child: _buildTimelineTiles(controller.serviceProgress.value, primary_300, warning_300),
    );
  });
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
                  fontSize: 14,
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
                      child: Column(
                        children: [
                          _buildInspectionItem('(F)Tyre', '(F)Tyre', borderInput_01, isLeftSide: false),
                          _buildInspectionItem('(F)Brake', '(F)Brake', borderInput_01, isLeftSide: false),
                          _buildInspectionItem('(F)Sprocket', '(F)Sprocket', borderInput_01, isLeftSide: false),
                          _buildInspectionItem('Chain', 'Chain', borderInput_01, isLeftSide: false),
                          _buildInspectionItem('Bearing', 'Bearing', borderInput_01, isLeftSide: false),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(1),
                child: Image.network('https://picsum.photos/100/100'),
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
                      child: Column(
                        children: [
                          _buildInspectionItem('Engine', 'Engine', borderInput_01, isLeftSide: true),
                          _buildInspectionItem('Lights', 'Lights', borderInput_01, isLeftSide: true),
                          _buildInspectionItem('(R)Brake', '(R)Brake', borderInput_01, isLeftSide: true),
                          _buildInspectionItem('(R)Sprocket', '(R)Sprocket', borderInput_01, isLeftSide: true),
                          _buildInspectionItem('(R)Tyre', '(R)Tyre', borderInput_01, isLeftSide: true),
                        ],
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
          Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.black)),
          if (!isLeftSide) _buildDropdown(key, borderInput_01),
        ],
      ),
    );
  }

Widget _buildDropdown(String key, Color borderInput_01) {
  return Obx(() {
    final score = controller.inspectionScores[key] ?? 0;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        border: Border.all(color: borderInput_01),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButton<int>(
        value: score,
        items: List.generate(10, (index) {
          return DropdownMenuItem(
            value: index + 1,
            child: Text((index + 1).toString()),
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
        underline: SizedBox(),
        icon: SizedBox.shrink(),
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
      Expanded(
        child: Obx(() => Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: primary_300),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: controller.isInspectionLoading.value ? null : controller.onInspectionPressed,
              child: Center(
                child: controller.isInspectionLoading.value
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(primary_300),
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Inspection',
                        style: TextStyle(
                          color: primary_300,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
        )),
      ),
      const SizedBox(width: 20),
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
              onTap: controller.isNextLoading.value ? null : controller.onNextPressed,
              child: Center(
                child: controller.isNextLoading.value
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
