
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Widget para exibir uma mensagem de erro com um ícone, texto e botão de ação.
class Error extends StatelessWidget{
  final String message;
  final VoidCallback onRetry;
  final IconData iconData;

  const Error({
    super.key,
    required this.iconData,
    required this.message,
    required this.onRetry
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // __________________________________________________________________
            Icon(
              iconData,
              size: 60,
              color: CupertinoColors.systemRed,
            ),

            // __________________________________________________________________
            // Texto de erro
            const SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: CupertinoColors.systemGrey),
            ),

            // __________________________________________________________________
            const SizedBox(height: 20),

            // __________________________________________________________________
            // Botão para tentar novamente
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar Novamente'),
            ),

          ],

        ),
      ),
    );
  }
}