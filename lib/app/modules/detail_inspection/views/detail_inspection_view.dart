import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai_technician/app/common/widgets/custom_back_button.dart';
import 'package:santai_technician/app/theme/app_theme.dart';
import '../controllers/detail_inspection_controller.dart';

class DetailInspectionView extends GetView<DetailInspectionController> {
  const DetailInspectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color borderInput_01 = Theme.of(context).colorScheme.borderInput_01;
    // final Color primary_300 = Theme.of(context).colorScheme.primary_300;

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
              _buildExteriorConditionSection(context),
              const SizedBox(height: 20),
              Divider(color: borderInput_01, height: 1),
              const SizedBox(height: 20),
              _buildLightsAndIndicatorsSection(context),
              const SizedBox(height: 20),
              Divider(color: borderInput_01, height: 1),
              const SizedBox(height: 20),
              _buildTailightSection(context),
              const SizedBox(height: 20),
              _buildNavigationButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExteriorConditionSection(BuildContext context) {
    final Color borderInput_01 = Theme.of(context).colorScheme.borderInput_01;
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Exterior Condition',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Text('Dents and Scratches', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        Column(
          children: controller.exteriorConditionLabels.map((label) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(label, style: TextStyle(fontSize: 16)),
                ),
                Expanded(
                  child: Obx(() => Checkbox(
                        value: controller.getExteriorCondition(label.toLowerCase()),
                        onChanged: (bool? newValue) =>
                            controller.setExteriorCondition(label.toLowerCase(), newValue!),
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
            Obx(() => _buildRatingStars('exterior')),
          ],
        ),
      ],
    );
  }

  Widget _buildLightsAndIndicatorsSection(BuildContext context) {
    final Color borderInput_01 = Theme.of(context).colorScheme.borderInput_01;
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Lights and Indicators',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Text('Headlight', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        ...controller.lightLabels.map((label) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 16)),
              Row(
                children: [
                  Row(
                    children: [
                      Obx(() => Checkbox(
                            value: controller.getLightStatus(
                                LightType.values.firstWhere(
                                    (e) => e.toString().split('.').last.toLowerCase() == label.toLowerCase().replaceAll(' ', '')),
                                'working'),
                            onChanged: (bool? newValue) => controller.setLightStatus(
                                LightType.values.firstWhere(
                                    (e) => e.toString().split('.').last.toLowerCase() == label.toLowerCase().replaceAll(' ', '')),
                                'working',
                                newValue!),
                            activeColor: primary_300,
                            checkColor: Colors.white,
                            side: BorderSide(color: borderInput_01, width: 2),
                          )),
                      const Text('Working', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Row(
                    children: [
                      Obx(() => Checkbox(
                            value: controller.getLightStatus(
                                LightType.values.firstWhere(
                                    (e) => e.toString().split('.').last.toLowerCase() == label.toLowerCase().replaceAll(' ', '')),
                                'notWorking'),
                            onChanged: (bool? newValue) => controller.setLightStatus(
                                LightType.values.firstWhere(
                                    (e) => e.toString().split('.').last.toLowerCase() == label.toLowerCase().replaceAll(' ', '')),
                                'notWorking',
                                newValue!),
                            activeColor: primary_300,
                            checkColor: Colors.white,
                            side: BorderSide(color: borderInput_01, width: 2),
                          )),
                      const Text('Not Working', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ],
          );
        }),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Rating', style: TextStyle(fontSize: 16)),
            Obx(() => _buildRatingStars('lights')),
          ],
        ),
      ],
    );
  }

  Widget _buildTailightSection(BuildContext context) {
    final Color borderInput_01 = Theme.of(context).colorScheme.borderInput_01;
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Tailight',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('Not Working', style: TextStyle(fontSize: 16)),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: controller.tailightLabels.map((label) {
                return Row(
                  children: [
                    Obx(() => Checkbox(
                          value: controller.getTailightStatus(label.toLowerCase()),
                          onChanged: (bool? value) {
                            if (value != null) {
                              controller.setTailightStatus(label.toLowerCase(), value);
                            }
                          },
                          activeColor: primary_300,
                          checkColor: Colors.white,
                          side: BorderSide(color: borderInput_01, width: 2),
                        )),
                    Text(label, style: TextStyle(fontSize: 16)),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Rating', style: TextStyle(fontSize: 16)),
            Obx(() => _buildRatingStars('tailight')),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingStars(String ratingKey) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            controller.setRating(ratingKey, index + 1);
          },
          child: Icon(
            Icons.star_rounded,
            color: index < (controller.ratings[ratingKey]?.value ?? 0)
                ? Color.fromARGB(255, 215, 163, 22)
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
            child: const Text('Previous', style: TextStyle(fontWeight: FontWeight.bold),),
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
            child: const Text('Next', style: TextStyle(fontWeight: FontWeight.bold),),
          ),
        ),
      ],
    );
  }
}




