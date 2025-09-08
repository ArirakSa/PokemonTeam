import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class ApiService {
  Future<List<Pokemon>> fetchPokemons() async {
    final url = Uri.parse("https://pokeapi.co/api/v2/pokemon?limit=30");
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Failed to load pokemons");
    }

    final data = json.decode(response.body);
    final results = data["results"] as List;

    return results.map((item) {
      final urlParts = item["url"].toString().split("/");
      final id = urlParts[urlParts.length - 2];

      return Pokemon(
        id: id,
        name: item["name"],
        imageUrl:
            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png",
      );
    }).toList();
  }
}
