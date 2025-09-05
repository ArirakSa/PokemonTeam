import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/team_controller.dart';

class PokemonList extends StatelessWidget {
  const PokemonList({super.key});

  TeamController get teamCtrl => Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
              labelText: "ค้นหา Pokémon",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) =>
                teamCtrl.searchQuery.value = value.toLowerCase(),
          ),
        ),

        // แสดงรายการ Pokémon
        Expanded(
          child: Obx(() {
            // กรองโปเกมอนตาม searchQuery โดย contains = ฟังก์ชันของ String ใน Dart ที่ใช้ค้นหา
            final filtered = teamCtrl.pokemons.where((p) {
              final name = p["name"]!.toLowerCase();
              return name.contains(teamCtrl.searchQuery.value);
            }).toList();
            
            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 3.5,
              ),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final pokemon = filtered[index];
                final name = pokemon["name"]!;
                final imageUrl = pokemon["imageUrl"]!;

                return Obx(() {
                  final selected = teamCtrl.team.any((p) => p["name"] == name);

                  return GestureDetector(
                    onTap: () => teamCtrl.togglePokemon(name),
                    child: AnimatedScale(
                      scale: selected ? 1.05 : 1.0, // ขยายตอนเลือก
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.elasticOut, // เด้งน่ารักๆ
                      child: Container(
                        decoration: BoxDecoration(
                          color: selected
                              ? Colors.yellow[100]
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            if (selected)
                              BoxShadow(
                                color: Colors.yellow.withValues(alpha: 0.6),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                          ],
                          border: Border.all(
                            color: selected ? Colors.orange : Colors.grey,
                            width: 2,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            // รูปโปเกมอน
                            Image.network(
                              imageUrl,
                              height: 120,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.error,
                                    size: 30,
                                    color: Colors.red,
                                  ),
                            ),

                            // ชื่อโปเกมอน
                            Expanded(
                              child: Text(
                                name,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),

                            // ไอคอนเลือกแบบเปลี่ยนมีแอนิเมชัน
                            Icon(
                              selected
                                  ? Icons.check_circle
                                  : Icons.add_circle_outline,
                              color: selected ? Colors.orange : Colors.grey,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
              },
            );
          }),
        ),
      ],
    );
  }
}
