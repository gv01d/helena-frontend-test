import 'package:company_testapp/widgets/company_status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/company.dart';

class CompanyItem extends StatelessWidget{
  // company data
  final Company company;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const CompanyItem({
    super.key,
    required this.company,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      child: ListTile(
        onTap: onTap,

        // ________________________________________________________________________
        // Avatar da Empresa
        leading: CircleAvatar(
          // Tenta carregar a imagem da URL, com um fallback em caso de erro.
          backgroundImage: NetworkImage(company.avatarUrl),
          onBackgroundImageError: (_, __) {}, // Simplesmente ignora o erro
          child: company.avatarUrl.isEmpty
              ? const Icon(Icons.business) // Ícone padrão se a URL for vazia
              : null,
        ),

        // ________________________________________________________________________
        // Titulo (Nome da Empresa)
        title: Text(company.nomeFantasia, style: TextStyle(fontWeight: FontWeight.bold)),

        // ________________________________________________________________________
        // Subtitulo (Razão Social e Quantidade de Funcionários)
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alinha os textos à esquerda
          children: [

            // Razão Social
            Text(
              company.razaoSocial,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 2), // Pequeno espaço entre as linhas

            // Numero de Funcionários
            Text('Funcionários: ${company.qtdeFuncionarios}'),
          ],
        ),

        // ________________________________________________________________________
        // Trailing
        trailing: Row(
          mainAxisSize: MainAxisSize.min, // Impede a Row de ocupar todo o espaço
          children: [

            // Status de atividade com ativaçao e desativaçao
            CompanyStatusChip(
              company: company,
              onToggleStatus: (bool oldStatus) {
                if(oldStatus)
                  onDelete();
              }
            ),

          ],
        ),

      ),
    );
  }
}