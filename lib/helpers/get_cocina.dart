import 'package:dio/dio.dart'; //CLiente dio para realizar peticiones
import 'package:lista_comida/entities/comidas.dart'; //importo la entidad o type
import 'package:lista_comida/models/comida.dart'; //importo el modelo de respuesta


class GetCocinaRespuesta {
  final _dio = Dio();

  //para llamar a la api usamos List para decirle que vendra una lista de datos y el modelo
  Future<List<Comidas>> getRespuesta() async {
    final respuesta = await _dio.get('http://localhost:8082/route.php/comida/');

    final data = respuesta.data;

    //Cuando la api devuelve una lista JSON
    if (data is List){
      return data
                .map<Comidas>((item)=>ComidaModel.fromJson(item).toMessageEntity())
                .toList();
    }

    //Si la Api devuelve un solo objeto y no una lista
    if (data is Map<String,dynamic>){
      final comidaModel = ComidaModel.fromJson(data);
      return [comidaModel.toMessageEntity()];
    }

    //CUando el formato no es correcto se debe lanzar una excepcion
    throw Exception('Formato de respuesta inesperado: ${data.runtimeType}');
  }
}
