import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/team_controller.dart';
import 'pokemon_list.dart';
import 'pokemon_preview.dart';
import 'team_overview.dart';

class Home extends StatelessWidget {
  Home({super.key});
  final TeamController teamCtrl = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            teamCtrl.currentTeam.value.name.isEmpty
                ? "สร้างทีมโปเกมอน"
                : "ทีม: ${teamCtrl.currentTeam.value.name}",
          ),
        ),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          // 1. ปุ่มแก้ไขชื่อทีม
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: "แก้ไขชื่อทีม",
            onPressed: () {
              final controller = TextEditingController(
                text: teamCtrl.currentTeam.value.name,
              );
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("แก้ไขชื่อทีม"),
                  content: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "ใส่ชื่อทีมใหม่",
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("ยกเลิก"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        teamCtrl.updateCurrentTeamName(controller.text);
                        Navigator.pop(context);
                      },
                      child: const Text("บันทึก"),
                    ),
                  ],
                ),
              );
            },
          ),

          // 2. ปุ่มบันทึกทีม (แสดงเมื่อมีโปเกมอน)
          Obx(
            () => teamCtrl.currentTeam.value.pokemons.isEmpty
                ? const SizedBox.shrink()
                : IconButton(
                    icon: const Icon(Icons.save),
                    tooltip: "บันทึกทีม",
                    onPressed: () {
                      teamCtrl.saveCurrentTeam();
                      
                      Get.snackbar(
                        "บันทึกสำเร็จ",
                        "บันทึกทีม ${teamCtrl.currentTeam.value.name} แล้ว",
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.green,
                        margin: const EdgeInsets.all(12),
                        colorText: Colors.white,
                      );
                      teamCtrl.clearCurrentTeam(); // รีเซ็ตหลังจากบันทึก
                    },
                  ),
          ),

          // 3. ปุ่มรีเซ็ตทีม (แสดงเมื่อมีโปเกมอน)
          Obx(
            () => teamCtrl.currentTeam.value.pokemons.isEmpty
                ? const SizedBox.shrink()
                : IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.red),
                    tooltip: "รีเซ็ตทีม",
                    onPressed: teamCtrl.clearCurrentTeam,
                  ),
          ),

          // 4. ปุ่มดูทีมทั้งหมด
          IconButton(
            icon: const Icon(Icons.list),
            tooltip: "ดูทีมทั้งหมด",
            onPressed: () => Get.to(() => TeamOverview()),
          ),
        ],
      ),
      body: Column(
        children: const [
          TeamPreview(), 
          Expanded(child: PokemonList()), 
        ],
      ),
    );
  }
}
