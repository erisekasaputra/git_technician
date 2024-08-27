import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai_technician/app/theme/app_theme.dart';
// import 'package:santai_technician/app/theme/app_theme.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

    @override
  Widget build(BuildContext context) {
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;
    final Color alert_300 = Theme.of(context).colorScheme.alert_300;
    final Color success_300 = Theme.of(context).colorScheme.success_300;
    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Expanded(child: _buildMainContent()),
                _buildBottomNavBar(context),
              ],
            ),
          ),
          Obx(() => Visibility(
            visible: controller.isOrderPopupVisible.value,
            child: Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 32),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 15,
                      offset: Offset(0, 8),
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'New Order!',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primary_300),
                    ),
                    Text('You have a new order request.'),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: controller.acceptOrder,
                          child: Text('Accept', style: TextStyle(color: Colors.white),),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: success_300,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: controller.rejectOrder,
                          child: Text('Reject', style: TextStyle(color: Colors.white),),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: alert_300,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: 100,
      title: Image.asset('assets/images/company_logo.png', height: 90),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Row(
            children: [
              const Text(
                'Online',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              Obx(() => Transform.scale(
                    scale: 0.7,
                    child: Switch(
                      value: controller.isOnline.value,
                      onChanged: controller.toggleOnlineStatus,
                      activeColor: Colors.white,
                      activeTrackColor: Colors.green,
                      inactiveThumbColor: Colors.black,
                      inactiveTrackColor: Colors.grey[300],
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    return const Center(
      child: Text(
        'Welcome to Santai Technician',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
  final Color primary_300 = Theme.of(context).colorScheme.primary;
  return Container(
    height: 80,
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 1,
          blurRadius: 5,
          offset: const Offset(0, -3),
        ),
      ],
    ),
    child: Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildNavItem(Icons.emoji_events, 'Reward', 0, primary_300),
        _buildNavItem(Icons.history, 'Job History', 1, primary_300),
        _buildNavItem(Icons.settings, 'Settings', 2, primary_300),
        _buildNavItem(Icons.attach_money, 'Financial', 3, primary_300),
        _buildNavItem(Icons.help, 'Support', 4, primary_300),
      ],
    )),
  );
}

Widget _buildNavItem(IconData icon, String label, int index, Color primary_300) {
  return GestureDetector(
    onTap: () => controller.changeTab(index),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon, 
          size: 35, 
          color: controller.currentIndex.value == index ? primary_300 : Colors.grey,
        ),
        Text(
          label, 
          style: TextStyle(
            fontSize: 12, 
            color: controller.currentIndex.value == index ? primary_300 : Colors.grey,
          ),
        ),
      ],
    ),
  );
}
}
