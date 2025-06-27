import 'package:flutter/material.dart';
import '../models/company.dart';
import '../services/api_service.dart';

// Possiveis estados da tela
enum ViewState { Idle, Loading, Error }

class CompanyProvider extends ChangeNotifier {
  // service para interagir com a API
  final ApiService _apiService = ApiService();

  // Lista de empresas
  List<Company> _companies = [];
  // Estado da tela
  ViewState _state = ViewState.Idle;
  // Mensagem de erro
  String _errorMessage = '';


  // getters
  List<Company> get companies => _companies;
  ViewState get state => _state;
  String get errorMessage => _errorMessage;

  // _______________________________________________________
  // metodo para buscar todas as empresas
  Future<void> fetchCompanies() async {
    // Define o estado como carregando
    _state = ViewState.Loading;
    notifyListeners();

    try {
      _companies = await _apiService.fetchCompanies();

      // Retorna o estado para Idle
      _state = ViewState.Idle;

      // Ordena a lista para mostrar os ativos primeiro
      _companies.sort((a, b) {
        if (a.active && !b.active) return -1; // Ativos primeiro
        if (!a.active && b.active) return 1; // Inativos depois
        return a.nomeFantasia.compareTo(b.nomeFantasia); // Ordena alfabeticamente
      });
    }
    catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _state = ViewState.Error;
    } finally {
      notifyListeners();
    }
  }

  // ________________________________________________________
  // metodo para adicionar uma empresa
  Future<void> addCompany(Company company) async {
    try {
      await _apiService.addCompany(company);
      await fetchCompanies(); // Recarrega a lista para refletir a adição
    } catch (e) {
      print('Erro ao adicionar empresa: $e');
      rethrow; // Propaga o erro para a UI tratar (ex: mostrar SnackBar)
    }
  }

  // _________________________________________________________
  // metodo para deletar uma empresa
  Future<void> deleteCompany(int id) async {
    try {
      await _apiService.deleteCompany(id);
      await fetchCompanies(); // Recarrega a lista
    } catch (e) {
      rethrow;
    }
  }
}