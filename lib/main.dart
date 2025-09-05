import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// Import controller & pages
import 'controllers/team_controller.dart';
import 'services/api_service.dart';
import 'pages/home.dart';

void main() async {
  // เริ่มระบบ storage สำหรับเก็บข้อมูลถาวร
  await GetStorage.init();

  // Register dependencies
  Get.lazyPut(() => ApiService()); // สร้าง ApiService เมื่อถูกเรียกครั้งแรก
  Get.put(TeamController()); // สร้าง TeamController ทันที

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pokémon Team',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.orange,
        scaffoldBackgroundColor: Colors.grey[50], // พื้นหลังแอป
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.orange, // AppBar
          foregroundColor: Colors.white, // ตัวหนังสือและไอคอนบน AppBar
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch:
              Colors.orange, // จะกำหนดสีหลักของ Dialog/TextField focus
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey), // กรอบ textfield
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.orange), // เวลา focus
          ),
          prefixIconColor: Colors.orange, // icon
        ),
      ),
      home: Home(),
    );
  }
}
