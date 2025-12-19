import 'package:dio/dio.dart';

class DelCocinaRespuesta {
  final _dio = Dio();

  Future<void> deleteCocina(String id_comida) async {
    final url = 'http://localhost:8082/route.php/comida/${id_comida}';
    try {
      final response = await _dio.delete(url);
      if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al eliminar libro');
    }
    } catch (e) {}
  }
}
