import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/company.dart';


class ApiService {
  final String _baseUrl = 'https://api.helena.run/test';

  final Map<String, String> _headers = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  // _________________________________________________________
  // Metodo para buscar todas as empresas

  /// Usa de um fetch para buscar todas as empresas na API.
  /// Retorna uma lista de objetos Company.
  Future<List<Company>> fetchCompanies() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/api/company'));

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

  // _________________________________________________________
  // Metodo para adicionar uma empresa

  /// adiciona uma nova empresa na API.
  /// Recebe um objeto Company e faz uma requisição POST.
  Future<void> addCompany(Company company) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/company'),
        headers: _headers,
        body: json.encode(company.toJson()),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Falha ao adicionar empresa. Código: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('Network error. Please check your connection.');
    } catch (e) {
      throw Exception('Error adding company: $e');
    }
  }

  // _________________________________________________________
  // Metodo para atualizar uma empresa

  /// Atualiza uma empresa existente na API.
  /// Recebe um objeto Company e faz uma requisição PUT.
  Future<void> updateCompany(Company company) async {
    try {
      print(company.avatarUrl);
      
      final response = await http.put(
        Uri.parse('$_baseUrl/api/company/${company.id}'),
        headers: _headers,
        body: json.encode(company.toJson())
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Falha ao atualizar empresa. Código: ${response.statusCode}');
      }
    } on SocketException { // Falha de conexão
      throw Exception('Falha de conexão. Verifique sua rede.');
    } catch (e) { // Outro erro
      throw Exception('Ocorreu um erro ao atualizar empresa: $e');
    }
  }

  // _________________________________________________________
  // metodo para "deletar" uma empresa (desativar)

  /// Deleta (desativa) uma empresa na API.
  /// Recebe o ID da empresa e faz uma requisição DELETE.
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