import 'dart:ui';
import 'package:flutter/material.dart';

import '../models/company.dart';

Future<void> showCustomEditDialog(BuildContext context, Company? company, Function(Company company) onSave) {

  final bool isAdding = company == null;

  final formKey = GlobalKey<FormState>();
  final nomeFantasiaController = TextEditingController(text: company?.nomeFantasia ?? '');
  final razaoSocialController = TextEditingController(text: company?.razaoSocial ?? '' );
  final employeesController = TextEditingController(text: company?.qtdeFuncionarios.toString() ?? '');
  final imageUrlController = TextEditingController(text: company?.avatarUrl ?? '');
  final activeStatusNotifier = ValueNotifier<bool>(company?.active ?? true);

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
            isAdding: isAdding,
            nomeFantasiaController: nomeFantasiaController,
            razaoSocialController: razaoSocialController,
            employeesController: employeesController,
            imageUrlController: imageUrlController,
            activeStatusNotifier: activeStatusNotifier,
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
                  id: company?.id ?? -1, // Se for novo, usa 0 ou o ID existente
                  nomeFantasia: nomeFantasiaController.text,
                  razaoSocial: razaoSocialController.text,
                  qtdeFuncionarios: int.parse(employeesController.text),
                  avatarUrl: imageUrlController.text,
                  active: activeStatusNotifier.value, // Pega o valor do status
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


class _EditFormWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final bool isAdding;
  final TextEditingController nomeFantasiaController;
  final TextEditingController razaoSocialController;
  final TextEditingController employeesController;
  final TextEditingController imageUrlController;
  final ValueNotifier<bool> activeStatusNotifier;


  const _EditFormWidget({
    required this.formKey,
    required this.isAdding,
    required this.nomeFantasiaController,
    required this.razaoSocialController,
    required this.employeesController,
    required this.imageUrlController,
    required this.activeStatusNotifier,

  });

  @override
  State<_EditFormWidget> createState() => _EditFormWidgetState();

}

// ________________________________________________________________________
// Widget que constrói o formulário de edição
class _EditFormWidgetState extends State<_EditFormWidget> {

  // Listener para atualizar a UI quando a URL da imagem mudar
  void _updateImagePreview() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.imageUrlController.addListener(_updateImagePreview);
  }

  @override
  void dispose() {
    widget.imageUrlController.removeListener(_updateImagePreview);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          // ________________________________________________________________________
          // Pré-visualização da imagem
          CircleAvatar(
            radius: 40,
            backgroundColor: Color.fromARGB(255, 34, 181, 153),
            backgroundImage: NetworkImage(widget.imageUrlController.text),
            onBackgroundImageError: (_, __) {},
            child: widget.imageUrlController.text.isEmpty
                ? const Icon(Icons.business, size: 40, color: const Color.fromARGB(255, 66, 66, 66))
                : null,
          ),
          const SizedBox(height: 16),

          // Mostra o campo de URL da imagem e o switch de status apenas se estiver adicionando
          if (widget.isAdding) ...[
            // __________________
            TextFormField(
              controller: widget.imageUrlController,
              decoration: const InputDecoration(
                labelText: 'URL da Imagem',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // ____________________
            // Usa um ValueListenableBuilder para reconstruir apenas o Switch quando seu valor mudar
            ValueListenableBuilder<bool>(
              valueListenable: widget.activeStatusNotifier,
              builder: (context, isActive, child) {
                return SwitchListTile(
                  activeColor: const Color.fromARGB(255, 34, 181, 153),
                  title: Text('Status : ${isActive?'Ativo' : 'Inativo'}'),
                  value: isActive,
                  onChanged: (newValue) {
                    widget.activeStatusNotifier.value = newValue;
                  },
                );
              },
            ),
            const SizedBox(height: 16),
          ] else ...[
            // No modo de edição, mostra o status como um Chip não editável
            Chip(
              label: Text(
                widget.activeStatusNotifier.value ? 'Ativo' : 'Inativo',
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: widget.activeStatusNotifier.value ? const Color.fromARGB(255, 34, 181, 153) : Colors.grey,
            ),
            const SizedBox(height: 16),
          ],

          // ________________________________________________________________________
          // Nome
          TextFormField(
            controller: widget.nomeFantasiaController,
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
            controller: widget.razaoSocialController,
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
            controller: widget.employeesController,
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
