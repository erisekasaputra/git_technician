import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:santai_technician/app/common/widgets/custom_toast.dart';
import 'package:santai_technician/app/data/models/common/base_error.dart';
import 'package:santai_technician/app/domain/entities/authentikasi/auth_user_register.dart';
import 'package:santai_technician/app/domain/usecases/authentikasi/register_user.dart';
import 'package:santai_technician/app/exceptions/custom_http_exception.dart';
import 'package:santai_technician/app/modules/register_otp/controllers/register_otp_controller.dart';
import 'package:santai_technician/app/routes/app_pages.dart';
import 'package:santai_technician/app/services/logout.dart';

class SignUpController extends GetxController {
  final registerOtpController = Get.isRegistered<RegisterOtpController>()
      ? Get.find<RegisterOtpController>()
      : null;
  final Logout logout = Logout();
  final isLoading = false.obs;
  final isAgreed = false.obs;
  final errorValidation = Rx<ErrorResponse?>(null);

  TextEditingController passwordController = TextEditingController();
  final isPasswordHidden = true.obs;

  TextEditingController phoneController = TextEditingController();
  final countryISOCode = ''.obs;
  final countryCode = ''.obs;
  final phoneNumber = ''.obs;

  final privacyPolicy = """
  ### Privacy Policy
  We value your privacy and take the protection of your personal information seriously.

  #### Your Privacy
  - We collect your personal data for:
    - Delivering products and services.
    - Marketing and improving our services.
  - Only authorized employees access your data.
  - Your information will **not be disclosed to third parties**, except as required for:
    - Service delivery (e.g., shipping products, security checks).
    - Regulatory, legal, or research purposes.
    - With your explicit consent.

  #### Your Consent
  - Your personal information (e.g., name, email, address, or credit card details) will **not be sold or shared** without permission.

  #### Communication & Marketing
  - We may update you about:
    - Latest products.
    - News and offers.
  - Opt-out anytime through:
    - 'Your Account' section on our website.
    - The "unsubscribe" link in our emails.

  ---

  ### Cookies
  Cookies enhance your browsing experience by:
  - Saving your login details for faster access.
  - Providing statistical data for service improvement.

  *Tip:* Adjust your browser settings to manage cookies as needed.

  ---

  ### Data & Statistics
  - We may share anonymized data, such as visitor counts, with:
    - Investors.
    - Research companies.
  - Collected data helps us improve user experience.

  ---

  ### Disclosures of Your Information
  Your data may be disclosed:
  1. If Santai Technology buys/sells assets or businesses.
  2. For compliance with legal obligations.
  3. To protect the rights or safety of our users and company.

  ---

  ### Shipping, Cancellation, and Refund Policy

  #### Shipping Policy
  - We only ship to valid **billing or shipping addresses**. 
  - **Delivery Time**: 2-5 working days (Monday to Friday).
  - **Tracking**: A tracking ID will be shared once your package is shipped.

  #### Change in Shipping Address
  - Requests must be made **within 12 hours** of order submission.
  - Address changes after 24 hours may incur additional shipping charges.

  ---

  #### Cancellation Policy
  - Cancellation is allowed **before shipment** with no extra fees.
  - Submit cancellation requests within **12 hours** of order placement.

  ---

  #### Return Policy
  Returns are accepted for:
  - **Failed Delivery**.
  - **Wrong Delivery**.
  - **Damaged Goods**.

  Requirements for returns:
  - Proof of purchase (order number and receipt).
  - Goods in original packaging, unused and undamaged.
  - Shipped back within **7 working days** of receipt.

  ---

  #### Refund Policy
  - Refunds are processed once returned goods meet our criteria.
  - Methods:
    - **Online Transfers**: Refunded to your bank account in 3-5 days.
    - **Credit Card**: Refunds issued to the card used for payment.

  ---

  ### Third-Party Sites
  - Links to partner websites are governed by their own privacy policies. 
  - **We are not responsible for third-party practices**—please review their policies before sharing data.

  ---

  ### Contact Us
  We're always happy to hear from you! Whether it's feedback or complaints, reach out to us at:

  **Email**: fadzle@santaitechnology.com  
  We'll respond promptly and do our best to assist you.

  ---

  ### Final Note
  Santai Technology reserves the right to amend this policy without prior notification. Your continued use of our services signifies your acceptance of the updated terms.
  """
      .obs;

  final termsAndCondition = """
  ### Welcome to Santai Technology Advancement & Research Online Store

  Terms and conditions stated below apply to all visitors and users of [https://www.santaitechnology.com/](https://www.santaitechnology.com/). You are bound by these terms and conditions as long as you're on [https://www.santaitechnology.com/](https://www.santaitechnology.com/).

  ---

  ### General

  The content of terms and conditions may be changed, moved, or deleted at any time. Please note that [https://www.santaitechnology.com/](https://www.santaitechnology.com/) has the rights to change the contents of the terms and conditions without any notice. Any violation of rules and regulations of these terms and conditions, [https://www.santaitechnology.com/](https://www.santaitechnology.com/) will take immediate actions against the offender(s).

  ---

  ### Site Contents & Copyrights

  Unless otherwise noted, all materials, including images, illustrations, designs, icons, photographs, video clips, and written and other materials that appear as part of this Site, in other words “Contents of the Site,” are copyrights, trademarks, trade dress, and/or other intellectual properties owned, controlled, or licensed by Santai Technology Advancement & Research.

  ---

  ### Comments and Feedbacks

  All comments and feedback to Santai Technology Advancement & Research will be directed to fadzle@santaitechnology.com.  
  Users shall agree that there will be no comment(s) submitted to [https://www.santaitechnology.com/](https://www.santaitechnology.com/) that will violate any rights of any third party, including copyrights, trademarks, privacy of other personal or proprietary rights. Furthermore, users shall agree there will not be content of unlawful, abusive, or obscene material(s) submitted to the site. Users will be the only ones responsible for any comment's content made.

  ---

  ### Product Information

  We cannot guarantee that all actual products will be exactly the same as shown on the monitor, as this depends on the user's monitor.

  ---

  ### Newsletter

  Users shall agree that [https://www.santaitechnology.com/](https://www.santaitechnology.com/) may send newsletters regarding the latest news/products/promotions, etc., through email to the user.

  ---

  ### Indemnification

  The user shall agree to defend, indemnify, and hold [https://www.santaitechnology.com/](https://www.santaitechnology.com/) harmless from and against any and all claims, damages, costs, and expenses, including attorneys' fees, arising from or related to your use of the Site.

  ---

  ### Link to Other Sites

  Any access link to third-party sites is at your own risk. [https://www.santaitechnology.com/](https://www.santaitechnology.com/) will not be responsible or involved with any such website if the user's content/product(s) got damaged or lost in connection with a third-party site.

  ---

  ### Inaccuracy Information

  From time to time, there may be information on [https://www.santaitechnology.com/](https://www.santaitechnology.com/) that contains typographical errors, inaccuracies, or omissions that may relate to product description, pricing, availability, and article contents. We reserve the right to correct any errors, inaccuracies, change, or edit information without prior notice to the customers. If you are not satisfied with your purchased product(s), please return it back to us with the invoice.

  ---

  ### Termination

  This agreement is effective unless and until either the customer or [https://www.santaitechnology.com/](https://www.santaitechnology.com/). Customers may terminate this agreement at any time. However, [https://www.santaitechnology.com/](https://www.santaitechnology.com/) may also terminate the agreement with the customer without any prior notice and will deny access to the customer who is unable to comply with the terms and conditions above.

  ---

  ### Shipping and Delivery Policy

  - **Items in stock**: 2-5 working days for Standard Delivery items.
  - **Items that are out of stock**: Please email or call us for assistance.

  ---

  ### Payments

  All goods purchased are subject to a one-time payment. Payment can be made through various payment methods we have available, such as Visa, MasterCard, or online payment methods.  
  Payment cards (credit cards or debit cards) are subject to validation checks and authorization by your card issuer. If we do not receive the required authorization, we will not be liable for any delay or non-delivery of your order.
  """
      .obs;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  final RegisterUser registerUser;
  SignUpController({required this.registerUser});

  void updatePhoneInfo(String isoCode, String code, String number) {
    countryISOCode.value = isoCode;
    countryCode.value = code;
    phoneNumber.value = number;
  }

  Future<void> signUp() async {
    isLoading.value = true;

    String password = passwordController.text;
    String selectedCountryISOCode = countryISOCode.value;
    String fullPhoneNumber = '${countryCode.value}${phoneNumber.value}';

    try {
      final dataUserRegister = UserRegister(
        phoneNumber: fullPhoneNumber,
        password: password,
        regionCode: selectedCountryISOCode,
        userType: 'MechanicUser',
      );

      final response = await registerUser(dataUserRegister);

      if (response == null || !response.isSuccess) {
        CustomToast.show(
          message: "Unable to create new account. Please try again shortly.",
          type: ToastType.success,
        );
        return;
      }

      if (registerOtpController != null) {
        registerOtpController!.otpSource.value = 'signup';
        registerOtpController!.otpRequestToken.value =
            response.next.otpRequestToken;
        registerOtpController!.otpRequestId.value = response.next.otpRequestId;
      }

      Get.toNamed(Routes.REGISTER_OTP, arguments: {
        'source': 'signup',
        'otpRequestToken': response.next.otpRequestToken,
        'otpRequestId': response.next.otpRequestId,
      });
    } catch (error) {
      if (error is CustomHttpException) {
        errorValidation.value = error.errorResponse;
        if (error.statusCode == 401) {
          await logout.doLogout();
          return;
        }

        if (error.errorResponse != null) {
          CustomToast.show(
            message: error.message,
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

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      // final String? accessToken = googleAuth.accessToken;
      final String? idToken = googleAuth.idToken;

      bool success = await sendTokenToServer(idToken);

      if (success) {
        Get.toNamed(Routes.REGISTER_OTP, arguments: {'source': 'signup'});
      } else {
        CustomToast.show(
          message: "Failed to authenticate with server",
          type: ToastType.error,
        );
      }
    } catch (error) {
      if (error is CustomHttpException) {
        if (error.statusCode == 401) {
          await logout.doLogout();
          return;
        }
        CustomToast.show(
          message: error.message,
          type: ToastType.error,
        );
        return;
      }
      CustomToast.show(
        message: "Uknown error has occured, Please try again later.",
        type: ToastType.error,
      );
    }
  }

  Future<bool> sendTokenToServer(String? token) async {
    return true;
  }
}
