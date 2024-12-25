enum OrderStatus {
  paymentPending, // 0
  paymentPaid, // 1
  findingMechanic, // 2
  mechanicAssigned, // 4
  mechanicDispatched, // 5
  mechanicArrived, // 6
  serviceInProgress, // 7
  serviceCompleted, // 8
  serviceIncompleted, // 9
  orderCancelledByUser, // 20
  orderCancelledByMechanic
}

extension OrderStatusExtension on OrderStatus {
  int get value {
    switch (this) {
      case OrderStatus.paymentPending:
        return 0;
      case OrderStatus.paymentPaid:
        return 1;
      case OrderStatus.findingMechanic:
        return 2;
      case OrderStatus.mechanicAssigned:
        return 4;
      case OrderStatus.mechanicDispatched:
        return 5;
      case OrderStatus.mechanicArrived:
        return 6;
      case OrderStatus.serviceInProgress:
        return 7;
      case OrderStatus.serviceCompleted:
        return 8;
      case OrderStatus.serviceIncompleted:
        return 9;
      case OrderStatus.orderCancelledByUser:
        return 20;
      case OrderStatus.orderCancelledByMechanic:
        return 21;
    }
  }
}
