import 'package:flutter/material.dart';
import '../models/company.dart';
import '../services/api_service.dart';

// Possiveis estados da tela
enum ViewState { idle, loading, error }

class CompanyProvider extends ChangeNotifier {
  // service para interagir com a API
  final ApiService _apiService = ApiService();

  // Lista de empresas
  List<Company> _companies = [];
  // Estado da tela
  ViewState _state = ViewState.idle;
  // Mensagem de erro
  String _errorMessage = '';


  // getters
  List<Company> get companies => _companies;
  ViewState get state => _state;
  String get errorMessage => _errorMessage;

  // _______________________________________________________
  /// metodo para buscar todas as empresas
  /// Busca as empresas da API e atualiza o estado
  Future<void> fetchCompanies() async {
    // Define o estado como carregando
    _state = ViewState.loading;
    notifyListeners();

    try {
      _companies = await _apiService.fetchCompanies();

      // Retorna o estado para Idle
      _state = ViewState.idle;

      // Ordena a lista para mostrar os ativos primeiro
      _companies.sort((a, b) {
        if (a.active && !b.active) return -1; // Ativos primeiro
        if (!a.active && b.active) return 1; // Inativos depois
        return a.nomeFantasia.compareTo(b.nomeFantasia); // Ordena alfabeticamente
      });
    }
    catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _state = ViewState.error;
    } finally {
      notifyListeners();
    }
  }

  // ________________________________________________________
  /// Método para adicionar uma empresa
  /// Adiciona uma nova empresa e recarrega a lista
  Future<void> addCompany(Company company) async {
    try {
      await _apiService.addCompany(company);
      await fetchCompanies(); // Recarrega a lista para refletir a adição
    } catch (e) {
      rethrow; // Propaga o erro para a UI tratar (ex: mostrar SnackBar)
    }
  }

  // _________________________________________________________
  /// Método para deletar uma empresa
  /// Deleta uma empresa pelo ID e recarrega a lista
  Future<void> deleteCompany(int id) async {
    try {
      await _apiService.deleteCompany(id);
      await fetchCompanies(); // Recarrega a lista
    } catch (e) {
      rethrow;
    }
  }

  // __________________________________________________________
  /// Método para atualizar uma empresa
  /// Atualiza uma empresa existente e recarrega a lista
  Future<void> updateCompany(Company company) async {
    try {
      await _apiService.updateCompany(company);
      await fetchCompanies(); // Recarrega a lista
    } catch (e) {
      rethrow;
    }
  }
}