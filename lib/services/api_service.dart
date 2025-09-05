import 'package:get/get.dart';

class ApiService {
  final client = GetConnect();

  // ดึงรายชื่อ Pokémon 27 ตัวแรกจาก PokeAPI
  Future<List<Map<String, String>>> fetchPokemons() async {
  final response = await client.get("https://pokeapi.co/api/v2/pokemon?limit=27");
  if (response.statusCode == 200) {
    return (response.body['results'] as List).map((p) {
      final url = p['url'].toString();
      final id = url.split("/")[6]; // ดึง id จาก url เช่น .../pokemon/1/
      return {
        "name": p['name'].toString(),
        "imageUrl": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png"
      };
    }).toList();
  }
  return [];
}

}
