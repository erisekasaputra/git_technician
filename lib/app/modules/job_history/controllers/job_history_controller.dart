import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:santai_technician/app/common/widgets/custom_toast.dart';
import 'package:santai_technician/app/domain/usecases/order/get_paginated_orders.dart';
import 'package:santai_technician/app/exceptions/custom_http_exception.dart';
import 'package:santai_technician/app/services/logout.dart';
import 'package:santai_technician/app/utils/custom_date_extension.dart';
import 'package:santai_technician/app/utils/http_error_handler.dart';
import 'package:santai_technician/app/utils/session_manager.dart';

class JobHistoryController extends GetxController {
  final SessionManager sessionManager = SessionManager();
  final isLoading = false.obs;
  final Logout logout = Logout();
  final GetPaginatedOrders getPaginatedOrders;
  final jobs = <Job>[].obs;
  final filteredJobs = <Job>[].obs;
  final expandedJobIndex = RxInt(-1);
  final lastPage = 1.obs;
  final pageCount = 10.obs;
  JobHistoryController({required this.getPaginatedOrders});

  @override
  void onInit() async {
    super.onInit();
    await fetchPaginatedOrders();
  }

  Future<void> fetchPaginatedOrders() async {
    isLoading.value = true;
    try {
      var timezone =
          await sessionManager.getSessionBy(SessionManagerType.timeZone);
      var data = await getPaginatedOrders(lastPage.value, pageCount.value);

      if (data == null || timezone.isEmpty || data.data.items.isEmpty) {
        return;
      }

      lastPage.value++;
      var newJobs = data.data.items
          .map((elm) {
            if (jobs.indexWhere(
                    (jobSearch) => jobSearch.orderId == elm.orderId) >
                -1) {
              return null;
            }

            return Job(
                orderId: elm.orderId,
                title: elm.buyer.buyerName,
                date: DateFormat('HH:mm:ss, dd MMM yyyy')
                    .format(elm.createdAtUtc.utcToLocal(timezone)),
                location: elm.addressLine,
                rating: elm.orderRating == null
                    ? 0
                    : elm.orderRating!.value.toInt(),
                description: elm.fleets.first.comment);
          })
          .where((iterateElement) => iterateElement != null)
          .whereType<Job>();

      jobs.addAll(newJobs);
      filteredJobs.clear();
      filteredJobs.addAll(jobs);
    } catch (error) {
      if (error is CustomHttpException) {
        if (error.statusCode == 401) {
          await logout.doLogout();
          return;
        }

        if (error.errorResponse != null) {
          var messageError = parseErrorMessage(error.errorResponse!);
          CustomToast.show(
            message: '${error.message}$messageError',
            type: ToastType.error,
          );
          return;
        }

        CustomToast.show(message: error.message, type: ToastType.error);
        return;
      } else {
        CustomToast.show(
          message: "An unexpected error has occured",
          type: ToastType.error,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  void filterJobs(String query) {
    if (query.isEmpty) {
      filteredJobs.assignAll(jobs);
    } else {
      filteredJobs.assignAll(jobs.where((job) =>
          job.title.toLowerCase().contains(query.toLowerCase()) ||
          job.location.toLowerCase().contains(query.toLowerCase()) ||
          job.description.toLowerCase().contains(query.toLowerCase())));
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
  final String orderId;
  final String title;
  final String date;
  final String location;
  final int rating;
  final String description;

  Job({
    required this.orderId,
    required this.title,
    required this.date,
    required this.location,
    required this.rating,
    required this.description,
  });
}
