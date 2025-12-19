import 'package:lista_comida/entities/comidas.dart';


class ComidaModel {
  final String id_comida;
  final String nombre_comida;
  final String autor;
  final String costo_comida;

  ComidaModel({
    required this.id_comida,
    required this.nombre_comida,
    required this.autor,
    required this.costo_comida,
  });

  factory ComidaModel.fromJson(Map<String, dynamic> json) => ComidaModel(
    id_comida: json['id_comida'],
    nombre_comida: json['nombre_comida'],
    autor: json['autor'],
    costo_comida: (json['costo_comida']),
  );

  //convertir el modelo a la entidad de dominio usada por la app.
  Comidas toMessageEntity() => Comidas(
    id_comida: id_comida,
    nombre_comida: nombre_comida,
    autor: autor,
    costo_comida: costo_comida,
  );

  //Serializa el modelo a map para enviarlo como request (ToJson)
  Map<String, dynamic> toJson() => {
    "id_comida": id_comida,
    "nombre_comida": nombre_comida,
    "autor": autor,
    "costo_comida": costo_comida,
  };
}
