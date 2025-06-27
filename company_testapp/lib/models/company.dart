class Company{
  final int? id;
  final String nomeFantasia;
  final String avatarUrl;
  final String razaoSocial;
  final int qtdeFuncionarios;
  final bool active;

  Company({
    this.id,
    required this.nomeFantasia,
    required this.avatarUrl,
    required this.razaoSocial,
    required this.qtdeFuncionarios,
    required this.active,
  });

  // Factory constructor to create a Company instance from a JSON map.
  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'] ?? 0,
      nomeFantasia: json['nomeFantasia'] ?? 'Nome não informado',
      avatarUrl: json['avatarUrl'] ?? '',
      razaoSocial: json['razaoSocial'] ?? '',
      qtdeFuncionarios: json['qtdeFuncionarios'] ?? 0,
      active: json['active'] ?? false,
    );
  }

  // Method to convert a Company instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomeFantasia': nomeFantasia,
      'avatarUrl': avatarUrl,
      'razaoSocial': razaoSocial,
      'qtdeFuncionarios': qtdeFuncionarios,
      'active': active,
    };
  }
}