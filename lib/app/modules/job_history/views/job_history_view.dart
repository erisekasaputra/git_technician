import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai_technician/app/common/widgets/custom_back_button.dart';
import 'package:santai_technician/app/theme/app_theme.dart';
import '../controllers/job_history_controller.dart';

class JobHistoryView extends GetView<JobHistoryController> {
  const JobHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final Color borderInput_01 = Theme.of(context).colorScheme.borderInput_01;
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
          'Job History',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: controller.filterJobs,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search, size: 30),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: borderInput_01),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Jobs completed',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: controller.filteredJobs.length + 1,
                itemBuilder: (context, index) {
                  if (index == controller.filteredJobs.length) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Obx(
                        () => controller.isLoading.value
                            ? Container(
                                width: 24, // Anda bisa sesuaikan ukuran
                                height: 40,
                                alignment: Alignment.center,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 4.0, // Sesuaikan ketebalan garis
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.green), // Warna progress
                                  backgroundColor: Colors
                                      .white, // Pastikan backgroundnya transparan
                                ),
                              )
                            : ElevatedButton(
                                onPressed: controller.isLoading.value
                                    ? null
                                    : controller
                                        .fetchPaginatedOrders, // Disable button if loading
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors
                                      .transparent, // Set button background to transparent
                                  overlayColor: Colors
                                      .transparent, // Set text color when not loading
                                  shadowColor:
                                      Colors.transparent, // Remove the shadow
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0,
                                      horizontal:
                                          20.0), // Padding for the button
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        1), // Rounded corners
                                    side: const BorderSide(
                                        color: Colors.transparent,
                                        width: 0), // Border color
                                  ),
                                ),
                                child: const Text('Load More'),
                              ),
                      ),
                    );
                  }
                  final job = controller.filteredJobs[index];
                  return JobCard(
                    job: job,
                    controller: controller,
                    index: index,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class JobCard extends StatelessWidget {
  final Job job;
  final JobHistoryController controller;
  final int index;

  const JobCard(
      {super.key,
      required this.job,
      required this.controller,
      required this.index});

  @override
  Widget build(BuildContext context) {
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;
    final Color warning_300 = Theme.of(context).colorScheme.warning_300;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 5,
      shadowColor: Colors.black.withOpacity(0.5),
      child: Obx(() {
        final isExpanded = controller.expandedJobIndex.value == index;
        return Column(
          children: [
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      job.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    color: primary_300,
                    weight: 4,
                    size: 30,
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 16, color: Colors.blue),
                          const SizedBox(width: 5),
                          Text(job.date),
                        ],
                      ),
                      Row(
                        children: List.generate(
                            5,
                            (index) => Icon(Icons.star_rounded,
                                weight: 4,
                                color: index < job.rating
                                    ? warning_300
                                    : Colors.grey,
                                size: 16)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: Colors.red),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          job.location,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              onTap: () => controller.toggleJobExpansion(index),
            ),
            if (isExpanded)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(job.description.isEmpty ? 'N/A' : job.description),
              ),
          ],
        );
      }),
    );
  }
}
