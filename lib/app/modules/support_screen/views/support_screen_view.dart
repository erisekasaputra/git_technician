import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai_technician/app/common/widgets/custom_back_button.dart';
import 'package:santai_technician/app/theme/app_theme.dart';
import '../controllers/support_screen_controller.dart';

class SupportScreenView extends GetView<SupportScreenController> {
  const SupportScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color borderInput_01 = Theme.of(context).colorScheme.borderInput_01;
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;
    final Color primary_100 = Theme.of(context).colorScheme.primary_100;

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
        leadingWidth: 60,
        title: const Text(
          'Support',
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
          Expanded(
            child: SingleChildScrollView(
              child: _buildFAQList(borderInput_01, primary_300),
            ),
          ),
          _buildContactSection(primary_100, primary_300),
        ],
      ),
    );
  }

  Widget _buildFAQList(Color borderInput_01, Color primary_300) {
    return Column(
      children: controller.faqItems.map((item) => _buildFAQItem(item, borderInput_01, primary_300)).toList(),
    );
  }

  Widget _buildFAQItem(String question, Color borderInput_01, Color primary_300) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderInput_01, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        title: Text(question, style: const TextStyle(color: Colors.black)),
        trailing: Icon(Icons.chevron_right, color: primary_300, weight: 2),
        onTap: () {
          // Handle FAQ item tap
        },
      ),
    );
  }

  Widget _buildContactSection(Color primary_100, Color primary_300) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primary_100, primary_300],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Would you like to our representative ?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildContactItem(Icons.phone, '(+60)3 412 3456'),
          _buildContactItem(Icons.email, 'support@santaitechnology.com'),
          _buildContactItem(Icons.chat, 'Live Agent'),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}