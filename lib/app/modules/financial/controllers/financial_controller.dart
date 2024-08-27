import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FinancialController extends GetxController {
  final totalFees = 0.0.obs;
  final jobsCompleted = 0.obs;
  final selectedWeek = 0.obs;
  final jobs = <Job>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadJobs();
  }

  void selectWeek(int index) {
    selectedWeek.value = index;
    loadJobs();
  }

  void loadJobs() {
    // Bersihkan jobs sebelumnya
    jobs.clear();

    // Dapatkan tanggal awal minggu ini
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    // Hitung tanggal awal untuk minggu yang dipilih
    final selectedStartDate = startOfWeek.subtract(Duration(days: 7 * selectedWeek.value));

    // Generate data dummy untuk satu minggu
    for (int i = 0; i < 7; i++) {
      final currentDate = selectedStartDate.add(Duration(days: i));
      final jobsPerDay = 2 + (i % 3); // 2-4 jobs per hari

      for (int j = 0; j < jobsPerDay; j++) {
        final job = Job(
          id: '#${600000 + jobs.length + 1}',
          vehicleNumber: 'VBB ${3000 + jobs.length + 1}',
          date: DateFormat('dd/MM/yyyy').format(currentDate),
          time: '${9 + j}:${(j * 30) % 60}'.padLeft(5, '0'),
          amount: 25.0 + (jobs.length % 5) * 5, // Variasi harga: 25, 30, 35, 40, 45
        );
        jobs.add(job);
      }
    }

    // Update totalFees dan jobsCompleted
    totalFees.value = jobs.fold(0, (sum, job) => sum + job.amount);
    jobsCompleted.value = jobs.length;
  }
}

class Job {
  final String id;
  final String vehicleNumber;
  final String date;
  final String time;
  final double amount;

  Job({
    required this.id,
    required this.vehicleNumber,
    required this.date,
    required this.time,
    required this.amount,
  });
}