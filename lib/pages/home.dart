import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/team_controller.dart';
import 'pokemon_list.dart';
import 'team_preview.dart';

class Home extends StatelessWidget {
  Home({super.key});
  final TeamController teamCtrl = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            teamCtrl.teamName.isEmpty
                ? "Name: Pokémon Team Builder"
                : "Name: ${teamCtrl.teamName.value}",
          ),
        ),
        actions: [
          // ปุ่มแก้ชื่อทีม
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: "แก้ไขชื่อทีม",
            onPressed: () {
              final controller = TextEditingController(
                text: teamCtrl.teamName.value,
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
                        teamCtrl.setTeamName(controller.text);
                        Navigator.pop(context);
                      },
                      child: const Text("บันทึก"),
                    ),
                  ],
                ),
              );
            },
          ),

          // ปุ่มรีเซ็ตทีม
          Obx(
            () => teamCtrl.team.isEmpty
                ? const SizedBox.shrink()
                : IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.red),
                    tooltip: "รีเซ็ตทีม",
                    onPressed: teamCtrl.resetTeam,
                  ),
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
