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
            // กรองโปเกมอนตาม searchQuery
            final filtered = teamCtrl.pokemons.where((p) {
              final name = p.name.toLowerCase(); // ✅ ใช้ p.name แทน p["name"]
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

                return Obx(() {
                  final selected = teamCtrl.currentTeam.value.pokemons
                      .any((p) => p.id == pokemon.id);

                  return GestureDetector(
                    onTap: () {
                      if (selected) {
                        teamCtrl.removePokemonFromCurrentTeam(pokemon.id);
                      } else {
                        teamCtrl.addPokemonToCurrentTeam(pokemon);
                      }
                    },
                    child: AnimatedScale(
                      scale: selected ? 1.05 : 1.0,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.elasticOut,
                      child: Container(
                        decoration: BoxDecoration(
                          color: selected
                              ? Colors.yellow[100]
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            if (selected)
                              BoxShadow(
                                color: Colors.yellow.withAlpha(153), // ✅ แก้เป็น withAlpha
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
                              pokemon.imageUrl, // ✅ ใช้ pokemon.imageUrl
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
                                pokemon.name, // ✅ ใช้ pokemon.name
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),

                            // ไอคอนเลือก
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