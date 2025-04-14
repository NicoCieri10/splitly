class PersonalSpent {
  final String nombre;
  final double total;
  final double pagado;

  PersonalSpent({
    required this.nombre,
    required this.total,
    required this.pagado,
  });

  factory PersonalSpent.fromJson(Map<String, dynamic> json) {
    return PersonalSpent(
      nombre: json['nombre'],
      total: json['total'].toDouble(),
      pagado: json['pagado'].toDouble(),
    );
  }
}
