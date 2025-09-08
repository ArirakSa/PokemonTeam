import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/team.dart';
import '../models/pokemon.dart';
import '../services/api_service.dart';

class TeamController extends GetxController {
  var teams = <Team>[].obs;
  var currentTeam = Team(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    name: '',
    pokemons: [],
  ).obs; // ทีมปัจจุบันที่กำลังแก้ไข

  var pokemons = <Pokemon>[].obs;
  var searchQuery = ''.obs; // คำค้นหา

  final storage = GetStorage(); // เก็บข้อมูลถาวร
  final ApiService api = Get.find(); // API service

  @override
  void onInit() {
    super.onInit();
    loadTeams();
    loadPokemons();
  }


  // ==============================
  // Pokemon
  // ==============================

  // โหลดโปเกมอนจาก API
  void loadPokemons() async {
    pokemons.value = await api.fetchPokemons();
  }

  // เพิ่มโปเกมอนในทีมปัจจุบัน
  void addPokemonToCurrentTeam(Pokemon pokemon) {
    if (currentTeam.value.pokemons.length < 3) {
      currentTeam.update((team) {
        team!.pokemons.add(pokemon);
      });
    } else {
      Get.snackbar(
        "ถึงขีดจำกัด",
        "คุณสามารถเลือกโปเกมอนได้ไม่เกิน 3 ตัว",
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        icon: const Icon(Icons.warning, color: Colors.yellow),
      );
    }
  }

  // ลบโปเกมอนจากทีมปัจจุบันที่กำลังเลือก
  void removePokemonFromCurrentTeam(String pokemonId) {
    currentTeam.update((team) {
      team!.pokemons.removeWhere((p) => p.id == pokemonId);
    });
  }

  // ==============================
  // Team
  // ==============================

  // โหลดทีมทั้งหมดจาก storage
  void loadTeams() {
    final storedTeams = storage.read<List>('teams') ?? [];
    teams.value = storedTeams
        .map((e) => Team.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  // บันทึกทีมทั้งหมดลง storage
  void saveTeams() {
    storage.write('teams', teams.map((t) => t.toJson()).toList());
  }

  // ตั้งชื่อทีมปัจจุบัน
  void updateCurrentTeamName(String name) {
    currentTeam.update((team) {
      team!.name = name;
    });
  }

  void saveCurrentTeam() {
    final index = teams.indexWhere((t) => t.id == currentTeam.value.id);

    if (index != -1) {
      // อัปเดตทีมเดิม
      teams[index] = Team(
        id: currentTeam.value.id,
        name: currentTeam.value.name,
        pokemons: List<Pokemon>.from(currentTeam.value.pokemons),
      );
    } else {
      // เพิ่มทีมใหม่
      teams.add(
        Team(
          id: currentTeam.value.id,
          name: currentTeam.value.name,
          pokemons: List<Pokemon>.from(currentTeam.value.pokemons),
        ),
      );
    }

    saveTeams(); // บันทึกลง storage
  }

  // สร้างทีมใหม่
  void createNewTeam() {
    currentTeam.value = Team(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: '',
      pokemons: [],
    );
  }

  // โหลดทีมมาแก้ไข
  void loadTeamForEditing(String teamId) {
    final team = teams.firstWhere((t) => t.id == teamId);
    currentTeam.value = Team(
      id: team.id,
      name: team.name,
      pokemons: List<Pokemon>.from(team.pokemons), // สร้าง List ใหม่
    );
  }

  // ลบทีม
  void deleteTeam(String teamId) {
    teams.removeWhere((t) => t.id == teamId);
    saveTeams();
  }

  void clearCurrentTeam() {
    currentTeam.update((team) {
      if (team != null) {
        team.name = ''; // รีเซ็ตชื่อเป็นค่าว่าง
        team.pokemons.clear(); // ลบโปเกมอนทั้งหมด
      }
    });
  }
}
