import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai_technician/app/common/widgets/custom_back_button.dart';
import 'package:santai_technician/app/theme/app_theme.dart';
import '../controllers/detail_inspection_controller.dart';

class DetailInspectionView extends GetView<DetailInspectionController> {
  const DetailInspectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final Color borderInput_01 = Theme.of(context).colorScheme.borderInput_01;
    // final Color primary_300 = Theme.of(context).colorScheme.primary_300;

    return Obx(
      () => Scaffold(
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
            'Inspection',
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Motorcycle\nPre-Service Inspection',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Divider(color: borderInput_01, height: 1),
                const SizedBox(height: 20),
                for (var preServiceInspection
                    in controller.preServiceInspections) ...[
                  _buildCondition(context, preServiceInspection)
                ],
                const SizedBox(height: 20),
                Divider(color: borderInput_01, height: 1),
                const SizedBox(height: 20),
                _buildNavigationButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCondition(
      BuildContext context, PreServiceInspectionObject preServiceInspection) {
    final Color borderInput_01 = Theme.of(context).colorScheme.borderInput_01;
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(preServiceInspection.parameter,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(preServiceInspection.parameter,
            style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        Column(
          children: preServiceInspection.preServiceInspectionResults
              .map((preServiceInspectionResultItem) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(preServiceInspectionResultItem.description,
                      style: const TextStyle(fontSize: 16)),
                ),
                Expanded(
                  child: Obx(() => Checkbox(
                        value: preServiceInspectionResultItem.isWorking.value,
                        onChanged: (bool? newValue) => controller.setCondition(
                            preServiceInspection.parameter,
                            preServiceInspectionResultItem.parameter,
                            newValue ?? false),
                        activeColor: primary_300,
                        checkColor: Colors.white,
                        side: BorderSide(color: borderInput_01, width: 2),
                      )),
                ),
              ],
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Rating', style: TextStyle(fontSize: 16)),
            Obx(() => _buildRatingStars(preServiceInspection.parameter,
                preServiceInspection.rating.value)),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingStars(String parentKey, int rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            controller.setRating(parentKey, index + 1);
          },
          child: Icon(
            Icons.star_rounded,
            color: index < controller.getRating(parentKey)
                ? const Color.fromARGB(255, 215, 163, 22)
                : Colors.grey,
            size: 24,
          ),
        );
      }),
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    final Color borderInput_01 = Theme.of(context).colorScheme.borderInput_01;
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: primary_300,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: borderInput_01, width: 1),
              ),
            ),
            onPressed: () => Get.back(),
            child: const Text(
              'Previous',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 80),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: primary_300,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: borderInput_01, width: 1),
              ),
            ),
            onPressed: controller.nextPage,
            child: const Text(
              'Next',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
