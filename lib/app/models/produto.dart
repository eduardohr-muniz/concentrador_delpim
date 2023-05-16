// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class Produto {
  final int bAtivo;
  final String sDescricao;
  final String sCodBarras;
  final double rPreco_Venda1;
  final double? rPreco_Venda2;
  final double? rPreco_Venda3;
  final double? rPreco_Promo;
  final String? sUndMedida;
  final int? iTopoPromo;

  Produto({
    required this.bAtivo,
    required this.sDescricao,
    required this.sCodBarras,
    required this.rPreco_Venda1,
    this.rPreco_Venda2,
    this.rPreco_Venda3,
    this.rPreco_Promo,
    this.sUndMedida,
    this.iTopoPromo,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'bAtivo': bAtivo,
      'sDescricao': sDescricao,
      'sCodBarras': sCodBarras,
      'rPreco_Venda1': rPreco_Venda1,
      'rPreco_Venda2': rPreco_Venda2,
      'rPreco_Venda3': rPreco_Venda3,
      'rPreco_Promo': rPreco_Promo,
      'sUndMedida': sUndMedida,
      'iTopoPromo': iTopoPromo,
    };
  }

  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      bAtivo: map['bAtivo'] ?? 1,
      sDescricao: map['sDescricao'] ?? "",
      sCodBarras: map['sCodBarras'] ?? 0,
      rPreco_Venda1: map['rPreco_Venda1'] ?? 0,
      rPreco_Venda2: map['rPreco_Venda2'] ?? 0,
      rPreco_Venda3: map['rPreco_Venda3'] ?? 0,
      rPreco_Promo: map['rPreco_Promo'] ?? 0,
      sUndMedida: map['sUndMedida'] ?? "",
      iTopoPromo: map['iTopoPromo'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Produto.fromJson(String source) => Produto.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProdutoModel(bAtivo: $bAtivo, sDescricao: $sDescricao, sCodBarras: $sCodBarras, rPreco_Venda1: $rPreco_Venda1, rPreco_Venda2: $rPreco_Venda2, rPreco_Venda3: $rPreco_Venda3, rPreco_Promo: $rPreco_Promo, sUndMedida: $sUndMedida, iTopoPromo: $iTopoPromo)';
  }
}
