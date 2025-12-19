//El apartado entities es como tipar la estructa de la tabla que tendra las acciones para evitar equivocaciones
class Comidas {
  final String id_comida;
  final String nombre_comida;
  final String autor;
  final String costo_comida;

  Comidas({
    required this.id_comida,
    required this.nombre_comida,
    required this.autor,
    required this.costo_comida,
  });
}
