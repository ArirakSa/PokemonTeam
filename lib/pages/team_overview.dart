import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/team_controller.dart';
import '../models/team.dart';

class TeamOverview extends StatelessWidget {
  TeamOverview({super.key});
  final TeamController teamCtrl = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ทีมโปเกมอนของฉัน")),
      body: Container(
        color: Colors.grey[200], // สีเทาอ่อนธรรมดา
        child: Obx(
          () => ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: teamCtrl.teams.length,
            itemBuilder: (context, index) {
              final team = teamCtrl.teams[index];
              return TeamCard(team: team);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          teamCtrl.createNewTeam();
          Get.back(); // กลับไปหน้า Home เพื่อสร้างทีมใหม่
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class TeamCard extends StatelessWidget {
  final Team team;
  final TeamController teamCtrl = Get.find();

  TeamCard({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    team.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  tooltip: "แก้ไขชื่อทีม",
                  onPressed: () => _editTeamName(context, team),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: "ลบทีม",
                  onPressed: () => _deleteTeam(context, team),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text("จำนวนโปเกมอน: ${team.pokemons.length}"),
            const SizedBox(height: 8),
            if (team.pokemons.isNotEmpty)
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: team.pokemons.map((pokemon) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Column(
                        children: [
                          Image.network(
                            pokemon.imageUrl,
                            height: 70,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.error, color: Colors.red),
                          ),
                          Text(pokemon.name),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                teamCtrl.loadTeamForEditing(team.id);
                Get.back(); // กลับไปหน้า Home เพื่อแก้ไขทีม
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text("แก้ไขทีม"),
            ),
          ],
        ),
      ),
    );
  }

  void _editTeamName(BuildContext context, Team team) {
    final controller = TextEditingController(text: team.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("แก้ไขชื่อทีม"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "ใส่ชื่อทีมใหม่"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("ยกเลิก"),
          ),
          ElevatedButton(
            onPressed: () {
              teamCtrl.teams[teamCtrl.teams.indexWhere(
                (t) => t.id == team.id,
              )] = Team(
                id: team.id,
                name: controller.text,
                pokemons: team.pokemons,
              );
              teamCtrl.saveTeams();
              Navigator.pop(context);
            },
            child: const Text("บันทึก"),
          ),
        ],
      ),
    );
  }

  void _deleteTeam(BuildContext context, Team team) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("ลบทีม"),
        content: Text("คุณต้องการลบทีม ${team.name} ใช่หรือไม่?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("ยกเลิก"),
          ),
          ElevatedButton(
            onPressed: () {
              teamCtrl.deleteTeam(team.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("ลบ"),
          ),
        ],
      ),
    );
  }
}
