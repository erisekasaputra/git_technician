import 'package:get/get.dart';

class JobHistoryController extends GetxController {
  final jobs = <Job>[].obs;
  final filteredJobs = <Job>[].obs;
  final expandedJobIndex = RxInt(-1);

  @override
  void onInit() {
    super.onInit();
    // Populate with sample data
    jobs.addAll([
      Job(
        title: 'EL 1',
        date: '22/07/2023',
        location: 'Batu Pahat',
        rating: 5,
        description: 'Vehicle well maintain, Next oil change is recommended at 50,000KM. Tyre thread is at 4mm would require change soon.',
      ),
      Job(
        title: 'EL 2',
        date: '23/07/2023',
        location: 'Johor Bahru',
        rating: 4,
        description: 'Another job description here.',
      ),
      // Add more sample jobs as needed
    ]);
    filteredJobs.addAll(jobs);
  }

  void filterJobs(String query) {
    if (query.isEmpty) {
      filteredJobs.assignAll(jobs);
    } else {
      filteredJobs.assignAll(jobs.where((job) =>
        job.title.toLowerCase().contains(query.toLowerCase()) ||
        job.location.toLowerCase().contains(query.toLowerCase()) ||
        job.description.toLowerCase().contains(query.toLowerCase())
      ));
    }
  }

  void toggleJobExpansion(int index) {
    if (expandedJobIndex.value == index) {
      expandedJobIndex.value = -1;
    } else {
      expandedJobIndex.value = index;
    }
  }
}

class Job {
  final String title;
  final String date;
  final String location;
  final int rating;
  final String description;

  Job({
    required this.title,
    required this.date,
    required this.location,
    required this.rating,
    required this.description,
  });
}