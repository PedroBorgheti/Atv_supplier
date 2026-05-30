class Supplier {
  Supplier({
    required this.id,
    required this.name,
    required this.cnpj,
    required this.phone,
    required this.description,
    required this.contractDate,
  });

  final String id;
  final String name;
  final String cnpj;
  final String phone;
  final String description;
  final DateTime contractDate;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cnpj': cnpj,
      'phone': phone,
      'description': description,
      'contractDate': contractDate.toIso8601String(),
    };
  }

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['id'] as String,
      name: json['name'] as String,
      cnpj: json['cnpj'] as String,
      phone: json['phone'] as String,
      description: json['description'] as String? ?? '',
      contractDate:
          DateTime.tryParse(json['contractDate'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Supplier copyWith({
    String? id,
    String? name,
    String? cnpj,
    String? phone,
    String? description,
    DateTime? contractDate,
  }) {
    return Supplier(
      id: id ?? this.id,
      name: name ?? this.name,
      cnpj: cnpj ?? this.cnpj,
      phone: phone ?? this.phone,
      description: description ?? this.description,
      contractDate: contractDate ?? this.contractDate,
    );
  }
}
