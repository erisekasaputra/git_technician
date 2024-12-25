import 'package:get/get.dart';

class FaqItem {
  String id;
  String question;
  String answer;

  FaqItem({required this.id, required this.question, required this.answer});
}

class SupportScreenController extends GetxController {
  final faqItems = RxList<FaqItem>([]);
  var expandedIndex = Rxn<String>();
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();

    faqItems.addAll([
      FaqItem(
          id: "ID1",
          question:
              'I accidentally canceled my order but the technician has arrive',
          answer: ''),
      FaqItem(
          id: "ID2",
          question:
              'How can i change the service location after i made my order?',
          answer: ''),
      FaqItem(
          id: "ID3",
          question: 'App error during the ordering process',
          answer: ''),
      FaqItem(
          id: "ID4",
          question: 'What can i do if can\'t book a services',
          answer: ''),
      FaqItem(
          id: "ID5",
          question:
              'How can i update my Santai registered phone number or email address?',
          answer: ''),
    ]);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // Toggle the expanded state of an FAQ item
  void toggleExpanded(String index) {
    if (expandedIndex.value == index) {
      expandedIndex.value = null; // Collapse if already expanded
    } else {
      expandedIndex.value = index; // Expand this item
    }
  }

  void increment() => count.value++;
}
