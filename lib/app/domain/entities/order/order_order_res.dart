import 'package:santai_technician/app/domain/enumerations/order_status.dart';
import 'package:santai_technician/app/domain/enumerations/percentage_or_value_type.dart';

class OrderResponse {
  final bool isSuccess;
  final OrderResponseData data;
  final String message;
  final String responseStatus;
  final List<dynamic> errors;
  final List<dynamic> links;
  final dynamic next;

  OrderResponse({
    required this.isSuccess,
    required this.data,
    required this.message,
    required this.responseStatus,
    required this.errors,
    required this.links,
    this.next,
  });
}

class OrderResponseData {
  final String orderId;
  final String secret;
  final String addressLine;
  final double latitude;
  final double longitude;
  final Buyer buyer;
  final Mechanic? mechanic;
  final List<LineItem> lineItems;
  final List<Fleet> fleets;
  final DateTime createdAtUtc;
  final bool isScheduled;
  final DateTime? scheduledAtUtc;
  final Payment? payment;
  final String? paymentUrl;
  final DateTime paymentExpiration;
  final String currency;
  final double orderAmount;
  final Discount? discount;
  final double grandTotal;
  final Rating? orderRating;
  final List<String>? ratingImages;
  final List<Fee> fees;
  final Cancellation? cancellation;
  final OrderStatus orderStatus;
  final bool isPaid;
  final bool isRated;
  final bool isPaymentExpire;

  OrderResponseData({
    required this.orderId,
    required this.secret,
    required this.addressLine,
    required this.latitude,
    required this.longitude,
    required this.buyer,
    this.mechanic,
    required this.lineItems,
    required this.fleets,
    required this.createdAtUtc,
    required this.isScheduled,
    this.scheduledAtUtc,
    this.payment,
    this.paymentUrl,
    required this.paymentExpiration,
    required this.currency,
    required this.orderAmount,
    this.discount,
    required this.grandTotal,
    this.orderRating,
    this.ratingImages,
    required this.fees,
    this.cancellation,
    required this.orderStatus,
    required this.isPaid,
    required this.isRated,
    required this.isPaymentExpire,
  });
}

class Buyer {
  final String buyerId;
  final String buyerName;
  final String buyerImageUrl;
  final String? email;
  final String? phoneNumber;

  Buyer({
    required this.buyerId,
    required this.buyerName,
    required this.buyerImageUrl,
    this.email,
    this.phoneNumber,
  });
}

class Mechanic {
  final String mechanicId;
  final String name;
  final String imageUrl;
  final Rating? rating;
  final double performance;
  final bool isRated;

  Mechanic({
    required this.mechanicId,
    required this.name,
    required this.imageUrl,
    this.rating,
    required this.performance,
    required this.isRated,
  });
}

class LineItem {
  final String lineItemId;
  final String name;
  final String sku;
  final double unitPrice;
  final String currency;
  final int quantity;
  final double? taxPercentage;
  final double? taxValue;
  final double subTotal;

  LineItem({
    required this.lineItemId,
    required this.name,
    required this.sku,
    required this.unitPrice,
    required this.currency,
    required this.quantity,
    this.taxPercentage,
    this.taxValue,
    required this.subTotal,
  });
}

class Fleet {
  final String fleetId;
  final String brand;
  final String model;
  final String registrationNumber;
  final String? imageUrl;
  final List<BasicInspection> basicInspections;
  final List<PreServiceInspection> preServiceInspections;
  final List<JobChecklist> jobChecklists;
  final String comment;

  Fleet(
      {required this.fleetId,
      required this.brand,
      required this.model,
      required this.registrationNumber,
      this.imageUrl,
      required this.basicInspections,
      required this.preServiceInspections,
      required this.jobChecklists,
      required this.comment});
}

class Payment {
  final String currency;
  final double amount;
  final DateTime? paidAt;
  final String? paymentMethod;
  final String? bankReference;

  Payment({
    required this.currency,
    required this.amount,
    this.paidAt,
    this.paymentMethod,
    this.bankReference,
  });
}

class Discount {
  final String couponCode;
  final PercentageOrValueType parameter;
  final String currency;
  final double valuePercentage;
  final double valueAmount;
  final double minimumOrderValue;
  final double discountAmount;

  Discount({
    required this.couponCode,
    required this.parameter,
    required this.currency,
    required this.valuePercentage,
    required this.valueAmount,
    required this.minimumOrderValue,
    required this.discountAmount,
  });
}

class Rating {
  final double value;
  final String? comment;

  Rating({
    required this.value,
    this.comment,
  });
}

class BasicInspection {
  final String description;
  final String parameter;
  int value;

  BasicInspection({
    required this.description,
    required this.parameter,
    required this.value,
  });
}

class PreServiceInspection {
  final String description;
  final String parameter;
  int rating;
  final List<PreServiceInspectionResult> preServiceInspectionResults;

  PreServiceInspection({
    required this.description,
    required this.parameter,
    required this.rating,
    required this.preServiceInspectionResults,
  });
}

class JobChecklist {
  final String description;
  final String parameter;
  bool value;

  JobChecklist(
      {required this.description,
      required this.parameter,
      required this.value});
}

class PreServiceInspectionResult {
  final String description;
  final String parameter;
  bool isWorking;

  PreServiceInspectionResult({
    required this.description,
    required this.parameter,
    required this.isWorking,
  });
}

class Cancellation {
  final List<Fee>? cancellationCharges;
  final double? cancellationRefundAmount;
  final String? currency;

  Cancellation({
    this.cancellationCharges,
    this.cancellationRefundAmount,
    this.currency,
  });
}

class Fee {
  final PercentageOrValueType parameter;
  final String feeDescription;
  final String currency;
  final double valuePercentage;
  final double valueAmount;
  final double feeAmount;

  Fee({
    required this.parameter,
    required this.feeDescription,
    required this.currency,
    required this.valuePercentage,
    required this.valueAmount,
    required this.feeAmount,
  });
}
