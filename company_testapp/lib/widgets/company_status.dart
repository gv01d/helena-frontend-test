import 'package:flutter/material.dart';

import '../models/company.dart';

/// Widget para exibir o status de uma empresa com opção de ativar/desativar
class CompanyStatusChip extends StatefulWidget {
  final Company company;
  final Function(bool ativoOuDesativo) onToggleStatus; // Callback to actually change status

  /// Construtor do widget CompanyStatusChip
  /// key: Chave opcional para o widget
  /// Company: A empresa cujo status será exibido
  /// onToggleStatus: Função callback que será chamada ao ativar/desativar a empresa
  const CompanyStatusChip({
    super.key,
    required this.company,
    required this.onToggleStatus,
  });

  @override
  _CompanyStatusChipState createState() => _CompanyStatusChipState();
}

class _CompanyStatusChipState extends State<CompanyStatusChip> {
  bool _isHovering = false;

  // Função para exibir o diálogo de confirmação
  Future<void> _showConfirmationDialog() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(

          // checagem se a empresa está ativa ou inativa
          title: Text(widget.company.active ? 'Desativar Empresa?' : 'Ativar Empresa?'),

          // ________________________________________________________________________
          // Mensagem de confirmação
          content: Text(
              'Você tem certeza que deseja ${widget.company.active ? 'desativar' : 'ativar'} a empresa "${widget.company.nomeFantasia}"?'),

          // ________________________________________________________________________
          // Ações do diálogo
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(dialogContext).pop(false); // User cancelled
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: widget.company.active ? Colors.red : Colors.green,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true); // User confirmed
              },
              child: Text(widget.company.active ? 'Desativar' : 'Ativar'),
            ),
          ],

        );
      },
    );

    if (confirmed == true) {
      widget.onToggleStatus(widget.company.active);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Detecçao de hover para mostrar o botão de ativar/desativar
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),

      // Mudar cursos para indicar que é clicável
      cursor: SystemMouseCursors.click,

      // Exibir o chip ou o botão de hover
      child: _isHovering && widget.company.active
          ? _buildHoverButton() // "disable/enable" button
          : _buildInfoChip(),    // regular chip
    );
  }

  Widget _buildInfoChip() {
    return Chip(
      label: Text(
        widget.company.active ? 'Ativo' : 'Inativo',
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: widget.company.active
          ? const Color.fromARGB(255, 34, 181, 153)
          : Colors.grey,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    );
  }

  Widget _buildHoverButton() {
    bool isActive = widget.company.active;
    String buttonText = isActive ? 'Desativar' : 'Ativar';
    IconData buttonIcon = isActive ? Icons.power_settings_new : Icons.play_circle_outline;
    Color buttonColor = isActive ? Colors.redAccent : Colors.green;

    return InkWell(
      onTap: _showConfirmationDialog,
      borderRadius: BorderRadius.circular(20), // Match chip-like shape

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), // Adjust padding

        // _________________
        // Borda e cor
        decoration: BoxDecoration(
          color: buttonColor.withAlpha(10), // Softer background for hover state
          border: Border.all(color: buttonColor),
          borderRadius: BorderRadius.circular(20),
        ),

        // _________________
        // Conteúdo do botão
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(buttonIcon, color: buttonColor, size: 16),
            const SizedBox(width: 4),
            Text(
              buttonText,
              style: TextStyle(color: buttonColor, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}