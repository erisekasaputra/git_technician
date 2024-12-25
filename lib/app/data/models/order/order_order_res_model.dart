import 'package:santai_technician/app/domain/entities/order/order_order_res.dart';
import 'package:santai_technician/app/domain/enumerations/order_status.dart';
import 'package:santai_technician/app/domain/enumerations/percentage_or_value_type.dart';

class OrderResponseModel extends OrderResponse {
  OrderResponseModel({
    required super.isSuccess,
    required OrderResponseDataModel super.data,
    required super.message,
    required super.responseStatus,
    required super.errors,
    required super.links,
    super.next,
  });

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderResponseModel(
      isSuccess: json['isSuccess'],
      data: OrderResponseDataModel.fromJson(json['data']),
      message: json['message'],
      responseStatus: json['responseStatus'],
      errors: json['errors'],
      links: json['links'],
      next: json['next'],
    );
  }
}

class OrderResponseDataModel extends OrderResponseData {
  OrderResponseDataModel({
    required super.orderId,
    required super.secret,
    required super.addressLine,
    required super.latitude,
    required super.longitude,
    required BuyerModel super.buyer,
    MechanicModel? super.mechanic,
    required List<LineItemModel> super.lineItems,
    required List<FleetModel> super.fleets,
    required super.createdAtUtc,
    required super.isScheduled,
    super.scheduledAtUtc,
    PaymentModel? super.payment,
    super.paymentUrl,
    required super.paymentExpiration,
    required super.currency,
    required super.orderAmount,
    DiscountModel? super.discount,
    required super.grandTotal,
    RatingModel? super.orderRating,
    super.ratingImages,
    required List<FeeModel> super.fees,
    CancellationModel? super.cancellation,
    required super.orderStatus,
    required super.isPaid,
    required super.isRated,
    required super.isPaymentExpire,
  });

  factory OrderResponseDataModel.fromJson(Map<String, dynamic> json) {
    return OrderResponseDataModel(
      orderId: json['orderId'],
      secret: json['secret'],
      addressLine: json['addressLine'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      buyer: BuyerModel.fromJson(json['buyer']),
      mechanic: json['mechanic'] != null
          ? MechanicModel.fromJson(json['mechanic'])
          : null,
      lineItems: (json['lineItems'] as List)
          .map((item) => LineItemModel.fromJson(item))
          .toList(),
      fleets: (json['fleets'] as List)
          .map((fleet) => FleetModel.fromJson(fleet))
          .toList(),
      createdAtUtc: DateTime.parse(json['createdAtUtc']),
      isScheduled: json['isScheduled'],
      scheduledAtUtc: json['scheduledAtUtc'] != null
          ? DateTime.parse(json['scheduledAtUtc'])
          : null,
      payment: json['payment'] != null
          ? PaymentModel.fromJson(json['payment'])
          : null,
      paymentUrl: json['paymentUrl'],
      paymentExpiration: DateTime.parse(json['paymentExpiration']),
      currency: json['currency'],
      orderAmount: (json['orderAmount'] as num).toDouble(),
      discount: json['discount'] != null
          ? DiscountModel.fromJson(json['discount'])
          : null,
      grandTotal: (json['grandTotal'] as num).toDouble(),
      orderRating: json['orderRating'] != null
          ? RatingModel.fromJson(json['orderRating'])
          : null,
      ratingImages: (json['ratingImages'] as List?)?.cast<String>(),
      fees:
          (json['fees'] as List).map((fee) => FeeModel.fromJson(fee)).toList(),
      cancellation: json['cancellation'] != null
          ? CancellationModel.fromJson(json['cancellation'])
          : null,
      orderStatus: OrderStatus.values.byName(json['orderStatus']),
      isPaid: json['isPaid'],
      isRated: json['isRated'],
      isPaymentExpire: json['isPaymentExpire'],
    );
  }
}

class BuyerModel extends Buyer {
  BuyerModel({
    required super.buyerId,
    required super.buyerName,
    required super.buyerImageUrl,
    super.email,
    super.phoneNumber,
  });

  factory BuyerModel.fromJson(Map<String, dynamic> json) {
    return BuyerModel(
      buyerId: json['buyerId'],
      buyerName: json['buyerName'],
      buyerImageUrl: json['buyerImageUrl'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
    );
  }
}

class MechanicModel extends Mechanic {
  MechanicModel({
    required super.mechanicId,
    required super.name,
    required super.imageUrl,
    RatingModel? super.rating,
    required super.performance,
    required super.isRated,
  });

  factory MechanicModel.fromJson(Map<String, dynamic> json) {
    return MechanicModel(
      mechanicId: json['mechanicId'],
      name: json['name'],
      imageUrl: !json.containsKey('imageUrl') ? '' : (json['imageUrl'] ?? ''),
      rating:
          json['rating'] != null ? RatingModel.fromJson(json['rating']) : null,
      performance: (json['performance'] as num).toDouble(),
      isRated: json['isRated'],
    );
  }
}

class LineItemModel extends LineItem {
  LineItemModel({
    required super.lineItemId,
    required super.name,
    required super.sku,
    required super.unitPrice,
    required super.currency,
    required super.quantity,
    super.taxPercentage,
    super.taxValue,
    required super.subTotal,
  });

  factory LineItemModel.fromJson(Map<String, dynamic> json) {
    return LineItemModel(
      lineItemId: json['lineItemId'],
      name: json['name'],
      sku: json['sku'],
      unitPrice: (json['unitPrice'] as num).toDouble(),
      currency: json['currency'],
      quantity: json['quantity'],
      taxPercentage: json['taxPercentage'] != null
          ? (json['taxPercentage'] as num).toDouble()
          : null,
      taxValue: json['taxValue'] != null
          ? (json['taxValue'] as num).toDouble()
          : null,
      subTotal: (json['subTotal'] as num).toDouble(),
    );
  }
}

class FleetModel extends Fleet {
  FleetModel(
      {required super.fleetId,
      required super.brand,
      required super.model,
      required super.registrationNumber,
      super.imageUrl,
      required List<BasicInspectionModel> super.basicInspections,
      required List<PreServiceInspectionModel> super.preServiceInspections,
      required List<JobChecklistModel> super.jobChecklists,
      required super.comment});

  factory FleetModel.fromJson(Map<String, dynamic> json) {
    return FleetModel(
      fleetId: json['fleetId'],
      brand: json['brand'],
      model: json['model'],
      registrationNumber: json['registrationNumber'],
      imageUrl: json['imageUrl'],
      basicInspections: (json['basicInspections'] as List)
          .map((inspection) => BasicInspectionModel.fromJson(inspection))
          .toList(),
      preServiceInspections: (json['preServiceInspections'] as List)
          .map((inspection) => PreServiceInspectionModel.fromJson(inspection))
          .toList(),
      jobChecklists: (json['jobChecklists'] as List)
          .map((job) => JobChecklistModel.fromJson(job))
          .toList(),
      comment: json['comment'],
    );
  }
}

class PaymentModel extends Payment {
  PaymentModel({
    required super.currency,
    required super.amount,
    super.paidAt,
    super.paymentMethod,
    super.bankReference,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      currency: json['currency'],
      amount: (json['amount'] as num).toDouble(),
      paidAt: json['paidAt'] != null ? DateTime.parse(json['paidAt']) : null,
      paymentMethod: json['paymentMethod'],
      bankReference: json['bankReference'],
    );
  }
}

class DiscountModel extends Discount {
  DiscountModel({
    required super.couponCode,
    required super.parameter,
    required super.currency,
    required super.valuePercentage,
    required super.valueAmount,
    required super.minimumOrderValue,
    required super.discountAmount,
  });

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      couponCode: json['couponCode'],
      parameter: PercentageOrValueType.values.firstWhere(
          (e) => e.toString() == 'PercentageOrValueType.${json['parameter']}'),
      currency: json['currency'],
      valuePercentage: (json['valuePercentage'] as num).toDouble(),
      valueAmount: (json['valueAmount'] as num).toDouble(),
      minimumOrderValue: (json['minimumOrderValue'] as num).toDouble(),
      discountAmount: (json['discountAmount'] as num).toDouble(),
    );
  }
}

class RatingModel extends Rating {
  RatingModel({
    required super.value,
    super.comment,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      value: (json['value'] as num).toDouble(),
      comment: json['comment'],
    );
  }
}

class BasicInspectionModel extends BasicInspection {
  BasicInspectionModel({
    required super.description,
    required super.parameter,
    required super.value,
  });

  factory BasicInspectionModel.fromJson(Map<String, dynamic> json) {
    return BasicInspectionModel(
      description: json['description'],
      parameter: json['parameter'],
      value: json['value'],
    );
  }

  static Map<String, dynamic> toJson(BasicInspection basicInspection) {
    return {
      'description': basicInspection.description,
      'parameter': basicInspection.parameter,
      'value': basicInspection.value
    };
  }
}

class JobChecklistModel extends JobChecklist {
  JobChecklistModel({
    required super.description,
    required super.parameter,
    required super.value,
  });

  factory JobChecklistModel.fromJson(Map<String, dynamic> json) {
    return JobChecklistModel(
      description: json['description'],
      parameter: json['parameter'],
      value: json['value'],
    );
  }
}

class PreServiceInspectionModel extends PreServiceInspection {
  PreServiceInspectionModel({
    required super.description,
    required super.parameter,
    required super.rating,
    required List<PreServiceInspectionResultModel>
        super.preServiceInspectionResults,
  });

  factory PreServiceInspectionModel.fromJson(Map<String, dynamic> json) {
    return PreServiceInspectionModel(
      description: json['description'],
      parameter: json['parameter'],
      rating: json['rating'],
      preServiceInspectionResults: (json['preServiceInspectionResults'] as List)
          .map((result) => PreServiceInspectionResultModel.fromJson(result))
          .toList(),
    );
  }

  static Map<String, dynamic> toJson(
      PreServiceInspection preServiceInspection) {
    return {
      'description': preServiceInspection.description,
      'parameter': preServiceInspection.parameter,
      'rating': preServiceInspection.rating,
      'preServiceInspectionResults': preServiceInspection
          .preServiceInspectionResults
          .map((result) => PreServiceInspectionResultModel.toJson(result))
          .toList()
    };
  }
}

class PreServiceInspectionResultModel extends PreServiceInspectionResult {
  PreServiceInspectionResultModel({
    required super.description,
    required super.parameter,
    required super.isWorking,
  });

  factory PreServiceInspectionResultModel.fromJson(Map<String, dynamic> json) {
    return PreServiceInspectionResultModel(
      description: json['description'],
      parameter: json['parameter'],
      isWorking: json['isWorking'],
    );
  }
  static Map<String, dynamic> toJson(
      PreServiceInspectionResult preServiceInspection) {
    return {
      'description': preServiceInspection.description,
      'parameter': preServiceInspection.parameter,
      'isWorking': preServiceInspection.isWorking
    };
  }
}

class FeeModel extends Fee {
  FeeModel({
    required super.parameter,
    required super.feeDescription,
    required super.currency,
    required super.valuePercentage,
    required super.valueAmount,
    required super.feeAmount,
  });

  factory FeeModel.fromJson(Map<String, dynamic> json) {
    return FeeModel(
      parameter: PercentageOrValueType.values.firstWhere(
          (e) => e.toString() == 'PercentageOrValueType.${json['parameter']}'),
      feeDescription: json['feeDescription'],
      currency: json['currency'],
      valuePercentage:
          double.tryParse(json['valuePercentage'].toString()) ?? 0.0,
      valueAmount: double.tryParse(json['valueAmount'].toString()) ?? 0.0,
      feeAmount: double.tryParse(json['feeAmount'].toString()) ?? 0.0,
    );
  }
}

class CancellationModel extends Cancellation {
  CancellationModel({
    List<FeeModel>? super.cancellationCharges,
    super.cancellationRefundAmount,
    super.currency,
  });

  factory CancellationModel.fromJson(Map<String, dynamic> json) {
    return CancellationModel(
      cancellationCharges: json['cancellationCharges'] != null
          ? (json['cancellationCharges'] as List)
              .map((fee) => FeeModel.fromJson(fee))
              .toList()
          : null,
      cancellationRefundAmount: json['cancellationRefundAmount'] != null
          ? double.tryParse(json['cancellationRefundAmount'].toString()) ?? 0.0
          : null,
      currency: json['currency'],
    );
  }
}
