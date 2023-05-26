import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Solicitacao {
  String slug;
  bool? bloquear;
  Solicitacao({
    required this.slug,
    this.bloquear,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'slug': slug,
      'bloquear': bloquear,
    };
  }

  factory Solicitacao.fromMap(Map<String, dynamic> map) {
    return Solicitacao(
      slug: map['slug'] as String,
      bloquear: map['bloquear'] != null ? map['bloquear'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Solicitacao.fromJson(String source) => Solicitacao.fromMap(json.decode(source) as Map<String, dynamic>);
}
