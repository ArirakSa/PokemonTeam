import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../services/api_service.dart';

class TeamController extends GetxController {
  var pokemons =
      <Map<String, String>>[].obs; // รายชื่อโปเกมอนจาก API [{name, imageUrl}]

  var team = <Map<String, String>>[].obs; // ทีมผู้ใช้เลือก (สูงสุด 3 ตัว)

  var teamName = ''.obs; // ชื่อทีม

  var searchQuery = ''.obs; // สำหรับค้นหา (จาก search bar)

  final storage = GetStorage(); // เก็บข้อมูลถาวร

  final ApiService api = Get.find(); // API service

  @override
  void onInit() {
    super.onInit();

    // โหลดชื่อทีมและชื่อจาก GetStorage
    final storedTeam = storage.read<List>('team') ?? [];
    team.value = storedTeam.map((e) => Map<String, String>.from(e)).toList();
    teamName.value = storage.read('teamName') ?? '';

    // เก็บทีมและชื่อลง storage ทุกครั้งที่เปลี่ยน
    ever(team, (_) => storage.write('team', team.toList()));
    ever(teamName, (_) => storage.write('teamName', teamName));

    loadPokemons();
  }

  // โหลดโปเกมอนจาก API
  void loadPokemons() async {
    pokemons.value = await api.fetchPokemons(); // [{name, imageUrl}]
  }

  // เลือก/ยกเลิกโปเกมอน
  void togglePokemon(String name) {
    final existing = team.firstWhereOrNull((p) => p["name"] == name);

    if (existing != null) {
      team.remove(existing); // ยกเลิก
    } else {
      if (team.length < 3) {
        // หาโปเกมอนจาก pokemons
        final poke = pokemons.firstWhereOrNull((p) => p["name"] == name);
        if (poke != null) {
          team.add({"name": poke["name"]!, "imageUrl": poke["imageUrl"]!});
        }
      } else {
        Get.snackbar(
          "ถึงขีดจำกัด",
          "คุณสามารถเลือกโปเกมอนได้ไม่เกิน 3 ตัว",
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red.shade700, // 🔴 พื้นหลังแดงเข้ม
          colorText: Colors.white, // ข้อความสีขาวอ่านง่าย
          margin: const EdgeInsets.all(12),
          icon: const Icon(Icons.warning, color: Colors.yellow), // ไอคอนสีขาว
        );
      }
    }
  }

  // ฟังก์ชันตั้งชื่อทีม
  void setTeamName(String name) {
    teamName.value = name;
    storage.write('teamName', name);
  }

  // รีเซ็ตทีม
  void resetTeam() {
    team.clear();
    teamName.value = '';
    storage.remove('team');
    storage.remove('teamName');
  }
}
