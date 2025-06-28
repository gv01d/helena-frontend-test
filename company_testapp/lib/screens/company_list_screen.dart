import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/company_provider.dart';
import '../widgets/company_item.dart';
import '../widgets/error.dart';
import '../widgets/edit_dialog.dart';

class CompanyListScreen extends StatefulWidget {
  const CompanyListScreen({super.key});

  @override
  State<CompanyListScreen> createState() => _CompanyListScreenState();
}

class _CompanyListScreenState extends State<CompanyListScreen> {

  Timer? _initialDelayTimer;
  Timer? _countdownTimer;

  int _countdownValue = 120;
  bool _showRefreshBar = false;
  bool _autoRefreshEnabled = true;

  @override
  void initState() {
    super.initState();

    // Fetch para carregar os dados assim que a tela é iniciada e iniciar o ciclo de timers
    Future.microtask(() => _fetchDataAndResetTimers());
  }

  @override
  void dispose() {
    // É crucial cancelar os timers para evitar memory leaks
    _initialDelayTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  /// Cancela todos os timers e reverte o estado da UI para o inicial.
  void _resetAllTimers() {
    setState(() {
      _showRefreshBar = false;
    });
    _initialDelayTimer?.cancel();
    _countdownTimer?.cancel();
    _countdownValue = 120;
  }

  /// Inicia a contagem decrescente de 2 minutos.
  void _startCountdownTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownValue > 0) {
        setState(() {
          _countdownValue--;
        });
      } else {
        // Quando o tempo acaba, busca os dados e reinicia o ciclo
        _fetchDataAndResetTimers();
      }
    });
  }

  /// Inicia o delay de 30 segundos. Após o delay, mostra a barra e inicia a contagem.
  void _startInitialDelay() {
    if (!_autoRefreshEnabled) return;

    _initialDelayTimer = Timer(const Duration(seconds: 60), () {
      setState(() {
        _showRefreshBar = true;
      });
      _startCountdownTimer();
    });
  }

  /// Função central que busca os dados e reinicia todo o ciclo de timers.
  Future<void> _fetchDataAndResetTimers() async {
    _resetAllTimers();
    // Usa o provider para buscar os dados
    await Provider.of<CompanyProvider>(context, listen: false).fetchCompanies();
    // Se a busca for bem-sucedida, inicia o delay de 30 segundos
    if (mounted && Provider.of<CompanyProvider>(context, listen: false).state == ViewState.Idle) {
      _startInitialDelay();
    }
  }

  /// Constrói a barra de atualização com os controlos.
  Widget _buildRefreshBar() {
    return Material(
      color: Colors.blue.withAlpha(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          children: [

            // Icone e timer de atualização
            if (_showRefreshBar && _autoRefreshEnabled) ...[
              const Icon(Icons.timer_outlined, size: 20, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                _showRefreshBar ? 'Atualizado pela ultima vez ${120 - (_countdownValue - 60)} segundos atrás' : '',
                style: const TextStyle(color: Colors.blue),
              ),
            ],
            const Spacer(),

            // Botao para ativar/desativar o auto refresh
            /*
            TextButton(
              onPressed: () {
                setState(() {
                  _autoRefreshEnabled = !_autoRefreshEnabled;
                  _resetAllTimers();
                });
              },
              child: Text('${_autoRefreshEnabled? 'Desativar' : 'Ativar'} auto refresh', style: const TextStyle(color: Colors.blueGrey)),
            ),
             */

            // Botão para atualizar os dados manualmente
            ElevatedButton.icon(
              onPressed: _fetchDataAndResetTimers,
              icon: const Icon(Icons.refresh, size: 18, color: Colors.white,),
              label: const Text('Atualizar empresas'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                backgroundColor: const Color.fromARGB(255,34, 151, 153),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        elevation: 2,
        shadowColor: const Color.fromARGB(255,34, 151, 153),
        title: const Text('   Helena Test APP - Empresas'),
        actions: [

          // Botão de adicionar empresa
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child:
            IconButton(
              icon: const Icon(Icons.add, color:  const Color.fromARGB(255,34, 151, 153), size: 50),

              tooltip: 'Adicionar Empresa',
              onPressed: () => showCustomEditDialog(
                context,
                null, // Passa null para criar uma nova empresa
                    (newCompany) async {
                  try {
                    await Provider.of<CompanyProvider>(context, listen: false)
                        .addCompany(newCompany);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Empresa adicionada com sucesso!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString().replaceFirst('Exception: ', '')),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ),


          )
        ],
      ),

      body: Column(
          children: [
            // Barra de atualizaçao
            _buildRefreshBar(),

            // __________________________________________________________________
            // Lista de empresas
            Expanded( child:
            Consumer<CompanyProvider>(
              builder: (ctx, provider, _) {

                // __________________________________________________________________
                // Status de Carregando
                if(provider.state == ViewState.Loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                // __________________________________________________________________
                // Status de Erro
                if(provider.state == ViewState.Error) {
                  return Error(
                      iconData: CupertinoIcons.exclamationmark_triangle,
                      message: provider.errorMessage,
                      onRetry: () => provider.fetchCompanies(),
                  );
                }

                // __________________________________________________________________
                // Se nao houver empresas
                if(provider.companies.isEmpty) {
                  return Error(
                    iconData: CupertinoIcons.xmark_circle,
                    message: "Nenhuma empresa encontrada.",
                    onRetry: () => provider.fetchCompanies(),
                  );
                }


                // __________________________________________________________________
                // Cria a visualizaçao baseada no provider
                return RefreshIndicator(
                  onRefresh: () =>
                    provider.fetchCompanies(),

                  child:
                  ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: provider.companies.length,

                    // __________________________________________________________________
                    // Cria os itens da lista de empresas
                    itemBuilder:
                      (ctx, i) => CompanyItem(
                        company: provider.companies[i],

                        // _________________________________________________________________
                        // Funçao de editar empresa com checagem de erro
                        onTap: () => showCustomEditDialog(
                          context,
                          provider.companies[i],
                          (updatedCompany) async {
                            try {
                              if (updatedCompany.id != null) {
                                // Atualiza a empresa existente
                                await provider.updateCompany(updatedCompany);
                              } else {
                                // erro
                                throw Exception('ID da empresa não pode ser nulo.');
                              }

                              // Exibe mensagem de sucesso
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Empresa salva com sucesso!'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            } catch (e) {
                              // Exibe mensagem de erro
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.toString().replaceFirst('Exception: ', '')),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },

                        ),

                        // _________________________________________________________________
                        // Funçao de delete com checagem de erro e confirmaçao
                        onDelete: () async {
                          try{
                            await provider.deleteCompany(provider.companies[i].id!);

                            // em sucesso
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Empresa desativada com sucesso!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          } catch(e){

                            // em erro
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e.toString().replaceFirst('Exception: ', '')),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      ),


                  ),


                );
              },
            ),
          )
        ]
      )
    );
  }
}