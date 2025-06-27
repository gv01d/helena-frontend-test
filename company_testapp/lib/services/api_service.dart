import 'dart:io';

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

  Future<void> addCompany(Company company) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/company'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(company.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to add company. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding company: $e');
    }
  }

  Future<void> deleteCompany(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/api/company/$id'),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete company. Status code: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('Network error. Please check your connection.');
    }catch (e) {
      throw Exception('Error deleting company: $e');
    }
  }
}