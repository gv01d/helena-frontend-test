class Company{
  final int? id;
  final String fantasyName;
  final String imageUrl;
  final int employees;
  final bool active;

  Company({
    this.id,
    required this.fantasyName,
    required this.imageUrl,
    required this.employees,
    required this.active,
  });

  // Factory constructor to create a Company instance from a JSON map.
  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'] ?? 0,
      fantasyName: json['fantasyName'] ?? 'Nome não informado',
      imageUrl: json['imageUrl'] ?? '',
      employees: json['employees'] ?? 0,
      active: json['active'] ?? false,
    );
  }

  // Method to convert a Company instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fantasyName': fantasyName,
      'imageUrl': imageUrl,
      'employees': employees,
      'active': active,
    };
  }
}