class GenerativeResponse {
  final double totalGastado;
  final List<String> personas;
  final List<PersonaGasto> porPersona;
  final List<Deuda> deudas;
  final List<String> notas;

  GenerativeResponse({
    required this.totalGastado,
    required this.personas,
    required this.porPersona,
    required this.deudas,
    required this.notas,
  });

  factory GenerativeResponse.fromJson(Map<String, dynamic> json) {
    return GenerativeResponse(
      totalGastado: json['resumen']['total_gastado'].toDouble(),
      personas: List<String>.from(json['resumen']['personas']),
      porPersona: (json['por_persona'] as List)
          .map((e) => PersonaGasto.fromJson(e))
          .toList(),
      deudas: (json['deudas'] as List).map((e) => Deuda.fromJson(e)).toList(),
      notas: List<String>.from(json['notas']),
    );
  }
}
