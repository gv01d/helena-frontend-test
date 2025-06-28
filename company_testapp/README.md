# company_testapp

helena company testapp

## project structure
company_testapp/
├── lib/
│   ├── main.dart
│   ├── models/ // Data models for API responses
│   │   ├── company.dart
│   ├── screens/
│   │   ├── company_list_screen.dart // Screen to list companies
│   ├── Providers/ // State management using Provider
│   │   ├── company_provider.dart
│   ├── services/ // Service layer for API calls
│   │   ├── api_service.dart
│   ├── widgets/ // widgets for UI components
│   │   ├── company_item.dart
│   │   ├── company_status.dart
│   │   ├── edit_dialog.dart
│   │   ├── error.dart
├── pubspec.yaml

## Observações
- O projeto foi rodado o argumento `--web-browser-flag "--disable-web-security"` para evitar problemas de CORS.
- O projeto utiliza o `provider` para gerenciamento de estado.
