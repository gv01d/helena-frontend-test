import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/company_provider.dart';
import '../widgets/company_item.dart';

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

            // __________________________________________________________________
            // Cria a visualizaçao baseada no provider
            return RefreshIndicator(
              onRefresh: () =>
                provider.fetchCompanies(),

              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: provider.companies.length,

                itemBuilder:
                  (ctx, i) => CompanyItem(
                    company: provider.companies[i],

                    // Delete function with error handling and confirmation dialog
                    onDelete: () async {
                      try{
                        await provider.deleteCompany(provider.companies[i].id!);

                        // on success
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Empresa deletada com sucesso!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } catch(e){

                        // on error
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
        )
    );
  }
}