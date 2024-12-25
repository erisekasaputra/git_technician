import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai_technician/app/common/widgets/custom_back_button.dart';
import 'package:santai_technician/app/routes/app_pages.dart';
import 'package:santai_technician/app/theme/app_theme.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

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
          'Setting',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileCard(context),
            _buildSettingsOptions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      shadowColor: Colors.black.withOpacity(0.7),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              const SizedBox(height: 10),
              Image.asset('assets/images/logo_hd_santaimoto_blue.png',
                  height: 100, width: double.infinity, fit: BoxFit.contain),
              const SizedBox(height: 40),
              Container(
                height: 2,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 50),
                    const Text(
                      'Technician Performance',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Obx(
                      () => Text(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        controller.userName.value,
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
          Positioned.fill(
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 5,
                  ),
                ),
                child: Stack(
                  children: [
                    Obx(
                      () => CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            controller.profileImageUrl.value.isEmpty
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
                    ),
                    Positioned(
                      bottom: -5,
                      right: -5,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.star_rounded,
                          color: Colors.yellow,
                          size: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOptions(BuildContext context) {
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;
    return Column(
      children: [
        _buildSettingItem('Profile', Icons.person, primary_300, () {
          Get.toNamed(Routes.USER_REGISTRATION, arguments: {'isUpdate': true});
        }),
        // _buildSettingItem(
        //     'Certificate', Icons.card_membership, primary_300, () {}),
        _buildSettingItem('Support', Icons.question_mark, primary_300, () {
          Get.toNamed(Routes.SUPPORT_SCREEN);
        }),
        _buildSettingItem(
            'Sign Out', Icons.card_membership, Colors.red.shade400, () async {
          await controller.logout();
        }),
      ],
    );
  }

  Widget _buildSettingItem(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      shadowColor: Colors.black.withOpacity(0.1),
      child: ListTile(
        leading: null,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: color),
        onTap: onTap,
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildWalletItem(Color primary_300) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      shadowColor: Colors.black.withOpacity(0.2),
      child: ListTile(
        leading: Icon(Icons.account_balance_wallet, color: primary_300),
        title: const Text('Santai Wallet'),
        trailing: Text(
          'RM ${controller.walletBalance.toStringAsFixed(2)}',
          style: const TextStyle(
              color: Colors.green, fontWeight: FontWeight.bold, fontSize: 14),
        ),
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
