import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/company_provider.dart';

class CompanyListScreen extends StatefulWidget {
  const CompanyListScreen({super.key});

  @override
  State<CompanyListScreen> createState() => _CompanyListScreenState();
}

class _CompanyListScreenState extends State<CompanyListScreen> {
  @override
  void initState() {
    super.initState();

    // Fetch para carregar os dados assim que a tela é iniciada
    Future.microtask(() =>
        Provider.of<CompanyProvider>(context, listen: false).fetchCompanies());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Helena Test APP - Empresas'),
      ),
        body: Consumer<CompanyProvider>(
          builder: (ctx, provider, _) {

            // Cria a visualizaçao baseada no provider
            return RefreshIndicator(
              onRefresh: () async {
                print("DEBUG: <Refresh_ListScreen> fetching companies");
                await provider.fetchCompanies();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: provider.companies.length,
                itemBuilder:
                    (ctx, i) => ListTile(
                      title: Text(provider.companies[i].nomeFantasia),
                      subtitle: Text(
                        'Funcionários: ${provider.companies[i].qtdeFuncionarios}',
                      ),
                      // Debug : botao de editar
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => {
                          print("Edit")
                        }
                      ),
                      // Debug : detectar o clique
                      onTap: () => {
                          print("Tapped on ${provider.companies[i].nomeFantasia}")
                        },
                    ),
              ),
            );
          },
        )
    );
  }
}