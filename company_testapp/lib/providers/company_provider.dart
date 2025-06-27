import 'package:flutter/material.dart';
import '../models/company.dart';
import '../services/api_service.dart';

class CompanyProvider extends ChangeNotifier {
  // service para interagir com a API
  final ApiService _apiService = ApiService();

  // Lista de empresas
  List<Company> _companies = [];

  // get para listar as empresas
  List<Company> get companies => _companies;

  // Método para buscar todas as empresas
  Future<void> fetchCompanies() async {
    try {
      print('DEBUG : <provider> Buscando empresas...');
      _companies = await _apiService.fetchCompanies();
    }
    catch (e) {
      print('Erro ao buscar empresas: $e');
    }
  }
}