import 'dart:convert';

import 'package:food_repository/food_repository.dart';
import 'package:http/http.dart';

class MenuRepository {
  Future<List<Food>> fetchMenu() async {
    Response response = await get(Uri.parse('https://api.jsonbin.io/v3/b/64d7298db89b1e2299cf70f1'),
        headers: {
          'X-Master-Key': r'''$2b$10$vrubNGoHa7oqyCejUlSJ9ORBy0kxQKDS0dL6x0zxLFoS30uapGT6C'''
        });
    if (response.statusCode == 200) {
      Map result = jsonDecode(response.body);
      List record = result['record'];
      return record
          .map((e) => Food(e['_id']['\$oid'], e['name'], e['description'], e['image'], e['price']))
          .toList();
    }
    throw Exception('Server responded with ${response.statusCode} : ${response.body}');
  }
}
