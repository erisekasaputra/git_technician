import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai_technician/app/common/widgets/custom_back_button.dart';
import 'package:santai_technician/app/theme/app_theme.dart';
import '../controllers/reward_controller.dart';

class RewardView extends GetView<RewardController> {
  const RewardView({super.key});

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
        leadingWidth: 100,
        title: const Text(
          'Reward',
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
              _buildPerformanceCard(context),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    _buildRewardsSection(),
                    const SizedBox(height: 20),
                    _buildRequirementsSection(),
                    const SizedBox(height: 20),
                    _buildConditionsSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceCard(BuildContext context) {
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;
    final Color warning_300 = Theme.of(context).colorScheme.warning_300;
    final Color borderInput_01 = Theme.of(context).colorScheme.borderInput_01;

    return Obx(
      () => Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: borderInput_01, width: 1),
        ),
        elevation: 10,
        shadowColor: Colors.black.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: controller.profileImageUrl.value.isEmpty
                    ? null
                    : Image.network(
                        '${controller.commonUrl.value}${controller.profileImageUrl.value}',
                      ).image,
                child: controller.profileImageUrl.value.isEmpty
                    ? const Icon(
                        Icons.person,
                        size: 35,
                        color: Colors.white,
                      )
                    : null,
              ),
              const SizedBox(height: 10),
              const Text(
                'Technician Performance',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Obx(
                          () => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star_rounded,
                                  color: warning_300, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                '${controller.rating.toStringAsFixed(1)} of 5.0',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Obx(
                            () => Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.calendar_today,
                                    color: Colors.lightBlue, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Since ${controller.activeDate.value}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          )),
                      // Container(
                      //   padding: const EdgeInsets.symmetric(
                      //       horizontal: 8, vertical: 4),
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.circular(10),
                      //     boxShadow: [
                      //       BoxShadow(
                      //         color: Colors.black.withOpacity(0.1),
                      //         spreadRadius: 2,
                      //         blurRadius: 10,
                      //         offset: Offset(0, 4),
                      //       ),
                      //     ],
                      //   ),
                      //   child: Row(
                      //     mainAxisSize: MainAxisSize.min,
                      //     children: [
                      //       Icon(Icons.check_circle,
                      //           color: success_300, size: 20),
                      //       const SizedBox(width: 8),
                      //       Obx(() => Text(
                      //             controller.isActive.value
                      //                 ? 'Active'
                      //                 : 'Inactive',
                      //             style: const TextStyle(
                      //               fontSize: 12,
                      //               color: Colors.black,
                      //             ),
                      //           )),
                      //     ],
                      //   ),
                      // ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              Obx(() => _buildProgressBar(
                  'Job Completed',
                  controller.totalCompletedJob.value,
                  controller.totalEntireJobBothCompleteIncomplete.value,
                  primary_300)),
              const SizedBox(height: 20),
              Obx(() => _buildProgressBar(
                  'Cancelation Rate',
                  controller.totalCancelledJob.value,
                  controller.totalEntireJob.value,
                  primary_300)),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(String label, int value, int total, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text('$value/$total'),
          ],
        ),
        const SizedBox(height: 10),
        LinearProgressIndicator(
          value: controller.safeDivision(value.toDouble(), total.toDouble()),
          backgroundColor: Colors.grey[100],
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 7,
          borderRadius: BorderRadius.circular(10),
        ),
      ],
    );
  }

  Widget _buildRewardsSection() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Rewards',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(controller.rewardDescription.value),
        ],
      ),
    );
  }

  Widget _buildRequirementsSection() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Requirements',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ...controller.requirements
              .map((req) => Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ', style: TextStyle(fontSize: 16)),
                        Expanded(
                            child: Text(req,
                                style: const TextStyle(fontSize: 16))),
                      ],
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildConditionsSection() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Conditions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          ...controller.conditions.map(
            (condition) => Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '• ',
                    style: TextStyle(fontSize: 16),
                  ),
                  Expanded(
                    child: Text(
                      condition,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
