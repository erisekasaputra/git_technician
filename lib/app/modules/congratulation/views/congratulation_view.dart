import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai_technician/app/theme/app_theme.dart';
import '../controllers/congratulation_controller.dart';
import 'package:santai_technician/app/common/widgets/custom_elvbtn_001.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class CongratulationView extends GetView<CongratulationController> {
  const CongratulationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color primary_100 = Theme.of(context).colorScheme.primary_100;
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/company_logo.png',
                height: 120,
              ),
              const SizedBox(height: 20),
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [primary_100, primary_300],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: const Text(
                  'Start Job',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
                Container(
                  height: 330,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: QRView(
                      key: GlobalKey(debugLabel: 'QR'),
                      onQRViewCreated: controller.onQRViewCreated,
                    ),
                  ),
                ),
              
              const SizedBox(height: 20),
              Obx(() => Text(
                'Scanned QR Code: ${controller.qrText.value}',
                textAlign: TextAlign.center,
              )),
              const SizedBox(height: 20),
              CustomElevatedButton(
                text: 'Next',
                onPressed: controller.isLoading.value ? null : controller.onNextPressed,
                isLoading: controller.isLoading.value,
              ),
            ],
          ),
        ),
      ),
    );
  }
}