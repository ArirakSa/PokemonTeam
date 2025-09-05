import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/team_controller.dart';

class TeamPreview extends StatelessWidget {
  const TeamPreview({super.key});
  TeamController get teamCtrl => Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Obx(() {
          if (teamCtrl.team.isEmpty) {
            return const Center(child: Text("ยังไม่มี Pokémon ในทีม"));
          }

          // จัด Pokémon ให้อยู่ตรงกลาง
          return Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min, // Row ขนาดพอดีกับจำนวน Pokémon
              children: teamCtrl.team.map((poke) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Stack(
                    children: [
                      Container(
                        width: 100,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.yellow[100],
                          border: Border.all(color: Colors.orange, width: 2),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.yellow.withValues(alpha: 0.6),
                              blurRadius: 4,
                              spreadRadius: 1,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: (poke["imageUrl"] != null)
                                  ? Image.network(
                                      poke["imageUrl"]!,
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, __, ___) =>
                                          const Icon(Icons.error, color: Colors.red),
                                    )
                                  : const Icon(Icons.catching_pokemon,
                                      color: Colors.redAccent),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              poke["name"] ?? "",
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.red, size: 20),
                          onPressed: () => teamCtrl.togglePokemon(poke["name"]!),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          tooltip: "ลบออกจากทีม",
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        }),
      ),
    );
  }
}
