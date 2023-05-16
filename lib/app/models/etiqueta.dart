// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Etiqueta {
  int id;
  String descricao;
  String script;

  Etiqueta({
    required this.id,
    required this.descricao,
    required this.script,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'descricao': descricao,
      'script': script,
    };
  }

  factory Etiqueta.fromMap(Map<String, dynamic> map) {
    return Etiqueta(
      id: map['id'] ?? 0,
      descricao: map['descricao'] ?? "",
      script: map['script'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory Etiqueta.fromJson(String source) => Etiqueta.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'EtiquetaModel(id: $id, descricao: $descricao, script: $script)';
}
