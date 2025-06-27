import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/company_provider.dart';
import '../widgets/company_item.dart';
import '../widgets/error.dart';

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

        // pequena barra separadora para decoração
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(
            height: 3.0,
            color: const Color.fromARGB(255,34, 151, 153),
          ),
        ),

      ),


      body: Consumer<CompanyProvider>(
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
          //
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

            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: provider.companies.length,

              itemBuilder:
                (ctx, i) => CompanyItem(
                  company: provider.companies[i],

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
      )
    );
  }
}