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
      _companies = await _apiService.fetchCompanies();
    }
    catch (e) {
      print('Erro ao buscar empresas: $e');
    }
  }

  Future<void> addCompany(Company company) async {
    try {
      await _apiService.addCompany(company);
      await fetchCompanies(); // Recarrega a lista para refletir a adição
    } catch (e) {
      print('Erro ao adicionar empresa: $e');
      rethrow; // Propaga o erro para a UI tratar (ex: mostrar SnackBar)
    }
  }

  Future<void> deleteCompany(int id) async {
    try {
      await _apiService.deleteCompany(id);
      await fetchCompanies(); // Recarrega a lista
    } catch (e) {
      rethrow;
    }
  }
}