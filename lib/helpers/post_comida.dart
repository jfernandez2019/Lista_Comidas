import 'package:dio/dio.dart'; // Cliente HTTP Dio para hacer peticiones REST
import 'package:lista_comida/entities/comidas.dart'; // Entidad de dominio 'Libros'
import 'package:lista_comida/models/comida.dart'; // Modelo para (de)serializar libros

class PostLibroService {
  // Servicio responsable de crear (POST) libros en el backend
  final _dio = Dio(); // Instancia de Dio reutilizable

  /// Crea un nuevo libro en el servidor.
  /// Devuelve true si la respuesta HTTP indica éxito (200/201).
  Future<bool> createComida(Comidas comidas) async {
    // Si el id viene vacío, no lo incluimos en el payload (autoincrement en DB).
    // Construimos el map que se enviará en el body de la petición.
    final Map<String, dynamic> data = comidas.id_comida.trim().isEmpty
        ? {
            'id_comida': comidas.id_comida,
            'nombre_comida': comidas.nombre_comida, // Nombre/título del libro
            'autor': comidas.autor, // Autor del libro
            'costo_comida': comidas.costo_comida, // Género o categoría
          }
        : ComidaModel(
            // Si el id está presente, usar el modelo para serializar incluyendo el id
            id_comida: comidas.id_comida,
            nombre_comida: comidas.nombre_comida,
            autor: comidas.autor,
            costo_comida: comidas.costo_comida,
          ).toJson(); // Convierte a Map<String, dynamic>

    // Ejecuta la petición POST al endpoint local (emulador Android usa 10.0.2.2)
    final response = await _dio.post(
      'http://localhost:8082/route.php/comida',
      data: data, // Body de la petición
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ), // Asegura content-type JSON
    );

    // Retorna true si el servidor devolvió 200 OK o 201 Created
    return response.statusCode == 200 || response.statusCode == 201;
  }
}
