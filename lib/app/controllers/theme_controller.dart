import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

class ThemeController extends GetxController {
  final _isDarkMode = false.obs;
  final _prefs = SharedPreferences.getInstance();

  bool get isDarkMode => _isDarkMode.value;

  @override
  void onInit() {
    super.onInit();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await _prefs;
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _isDarkMode.value = isDarkMode;
    _setTheme();
  }

  Future<void> toggleTheme() async {
    _isDarkMode.toggle();
    _setTheme();
    final prefs = await _prefs;
    await prefs.setBool('isDarkMode', _isDarkMode.value);
  }

  void _setTheme() {
    Get.changeTheme(_isDarkMode.value ? AppTheme.darkTheme : AppTheme.lightTheme);
  }
}

// final ThemeController themeController = Get.find<ThemeController>();
// themeController.toggleTheme();