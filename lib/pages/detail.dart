import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/team_controller.dart';

class TeamDetail extends StatelessWidget {
  TeamDetail({super.key});
  final TeamController teamCtrl = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
          teamCtrl.teamName.isEmpty
              ? "รายละเอียดทีม"
              : "ทีม: ${teamCtrl.teamName.value}",
        )),
      ),
      body: Obx(() {
        if (teamCtrl.team.isEmpty) {
          return const Center(child: Text("ยังไม่มี Pokémon ในทีม"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: teamCtrl.team.length,
          itemBuilder: (context, index) {
            final poke = teamCtrl.team[index];
            return Card(
              child: ListTile(
                leading: Image.network(
                  poke["imageUrl"]!,
                  width: 50,
                  height: 50,
                  errorBuilder: (_, __, ___) => const Icon(Icons.error),
                ),
                title: Text(poke["name"] ?? ""),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => teamCtrl.togglePokemon(poke["name"]!),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
