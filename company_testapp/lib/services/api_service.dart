import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/company.dart';


class ApiService {
  final String _baseUrl = 'https://api.helena.run/test';

  // Metodo para buscar todas as empresas
  Future<List<Company>> fetchCompanies() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/api/company'));
      print("DEBUG : response gotten: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Company.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load companies. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching companies: $e');
    }
  }
}