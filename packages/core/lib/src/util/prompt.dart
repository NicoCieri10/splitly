class PromptUtils {
  static String generarPrompt({
    required List<String> participantes,
    required List<Gasto> gastos,
    required Map<String, List<String>> consumos,
    required Map<String, List<String>> pagos,
  }) {
    final gastoTexto = gastos.map((g) => '${g.nombre}: ${g.monto}').join(', ');

    final consumoTexto = consumos.entries.map((e) {
      final lista = e.value.join(', ');
      return '- ${e.key} consumió: $lista.';
    }).join('\n');

    final pagosTexto = pagos.entries.map((e) {
      final lista = e.value.join(', ');
      return '- ${e.key} pagó: $lista.';
    }).join('\n');

    return '''
Te voy a pasar los detalles de una reunión con varias personas y sus consumos. Necesito que calcules automáticamente cuánto debe pagar cada persona, teniendo en cuenta lo que consumió y lo que ya pagó. Después, indicame quién le debe a quién y cuánto.

**Personas presentes:**
${participantes.join(', ')}

**Gastos totales:**
$gastoTexto

**Consumos individuales:**
$consumoTexto

**Quién pagó qué:**
$pagosTexto

**Formato de salida deseado:**
- Total a pagar por persona según su consumo.  
- Total pagado por cada persona.  
- Quién debe a quién y cuánto.  
- Que los totales cierren (verificación final).  
- Explicación clara y lista para compartir por WhatsApp.
''';
  }
}
