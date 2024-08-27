import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai_technician/app/theme/app_theme.dart';
import '../controllers/booking_accepted_controller.dart';

class BookingAcceptedView extends GetView<BookingAcceptedController> {
  const BookingAcceptedView({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: Text('Map will be implemented here'),
                  ),
                ),
              ),
            ],
          ),
          _buildRouteInfo(context),
          _buildBottomInfo(context)
        ],
      ),
    ),
  );
}

Widget _buildBottomInfo(BuildContext context) {
  final  Color primary_300 = Theme.of(context).colorScheme.primary_300;
  return Positioned(
    left: 20,
    right: 20,
    bottom: 20,
    child: Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 200),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildOrderInfo(),
            const SizedBox(height: 8),
            _buildActionButtons(primary_300),
          ],
        ),
      ),
    ),
  );
}

Widget _buildOrderInfo() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Pick-Up',
        style: TextStyle(fontSize: 14),
      ),
      Text(
        'Order ID: #${controller.orderId}',
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    ],
  );
}

Widget _buildActionButtons(Color primary_300) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      _buildActionButton(Icons.chat, 'Chat', primary_300),
      _buildActionButton(Icons.phone, 'Call', primary_300),
      _buildActionButton(Icons.location_on, 'Location', primary_300),
      _buildActionButton(Icons.qr_code, 'QR Code', primary_300),
    ],
  );
}

Widget _buildActionButton(IconData icon, String label, Color color) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    ],
  );
}

 Widget _buildRouteInfo(BuildContext context) {
  final  Color primary_300 = Theme.of(context).colorScheme.primary_300;
  return Positioned(
    top: 40,
    left: 20,
    right: 20,
    child: Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: primary_300,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.turn_left, color: Colors.white, size: 18),
                ),
                SizedBox(height: 4),
                Text(
                  '${controller.distance}m',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Route',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const Text('Turn Left', style: TextStyle(fontSize: 12)),
                  const Text('Onto main street', style: TextStyle(fontSize: 12)),
                  Text('Arrive at ${controller.arrivalTime}', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

 
}