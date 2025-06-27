import 'dart:ui';
import 'package:flutter/material.dart';

import '../models/company.dart';

Future<void> showCustomEditDialog(BuildContext context, Company company, Function(Company company) onSave) {

  final formKey = GlobalKey<FormState>();
  final nomeFantasiaController = TextEditingController(text: company.nomeFantasia);
  final razaoSocialController = TextEditingController(text: company.razaoSocial);
  final employeesController = TextEditingController(text: company.qtdeFuncionarios.toString());

  return showGeneralDialog(
    context: context,

    // Permite fechar o diálogo ao tocar fora dele
    barrierDismissible: true,

    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black.withAlpha(100), // Cor do fundo escurecido
    transitionDuration: const Duration(milliseconds: 100), // Duração da animação

    pageBuilder: (ctx, a1, a2) {
      return Center(

        child: AlertDialog(
          title: const Text('Editar Empresa'),
          content: _EditFormWidget(
            formKey: formKey,
            nomeFantasiaController: nomeFantasiaController,
            razaoSocialController: razaoSocialController,
            employeesController: employeesController,
          ),

          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('CANCELAR'),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 34, 181, 153), // Cor do botão
                foregroundColor: Colors.white, // Cor do texto
              ),
              onPressed: () {

                final updatedCompany = Company(
                  id: company.id,
                  nomeFantasia: nomeFantasiaController.text,
                  razaoSocial: razaoSocialController.text,
                  qtdeFuncionarios: int.parse(employeesController.text),
                  active: company.active,
                  avatarUrl: company.avatarUrl,
                );
                // Chama o callback com a empresa atualizada
                onSave(updatedCompany);

                Navigator.of(ctx).pop();
              },
              child: const Text('SALVAR'),
            )
          ],
        ),

      );
    },

    // Animação de transição personalizada
    transitionBuilder: (ctx, a1, a2, child) {

      // Filtro de desfoque para o fundo
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5 * a1.value, sigmaY: 5 * a1.value),
        child: FadeTransition(
          opacity: a1, // Animação de Fade (aparecimento suave)
          child: child,
        ),
      );
    },

  );
}


class _EditFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nomeFantasiaController;
  final TextEditingController razaoSocialController;
  final TextEditingController employeesController;

  const _EditFormWidget({
    required this.formKey,
    required this.nomeFantasiaController,
    required this.razaoSocialController,
    required this.employeesController,
  });

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          // ________________________________________________________________________
          // Nome
          TextFormField(
            controller: nomeFantasiaController,
            decoration: const InputDecoration(
              labelText: 'Nome Fantasia',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira o nome fantasia.';
              }
              return null;
            },
          ),

          // ________________________________________________________________________
          // Razão Social
          const SizedBox(height: 16),
          TextFormField(
            controller: razaoSocialController,
            decoration: const InputDecoration(
              labelText: 'Razão Social',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira a razão social.';
              }
              return null;
            },
          ),

          // ________________________________________________________________________
          // Quantidade de Funcionários
          const SizedBox(height: 16),
          TextFormField(
            controller: employeesController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Nº de Funcionários',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira o número de funcionários.';
              }
              final int? number = int.tryParse(value);
              if (number == null || number < 0) {
                return 'Por favor, insira um número válido.';
              }
              return null;
            },
          ),

        ],
      ),
    );
  }
}
