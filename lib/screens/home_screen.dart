import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lista_comida/entities/comidas.dart';
import 'package:lista_comida/helpers/get_cocina.dart'; //con esto puedo obtener la lista de comidas desde la api con GET
import 'package:lista_comida/helpers/del_cocina.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Comidas>> _comidasfuture;

  @override
  void initState() {
    super.initState();
    _comidasfuture = GetCocinaRespuesta().getRespuesta();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Comidas')),
      body: FutureBuilder<List<Comidas>>(
        future:
            _comidasfuture, //Future que se quiere utilizar , se esta observando
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            ); // Muestra indicador de carga
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
              ), // Muestra mensaje de error si falla
            );
          }

          final comidas = snapshot.data;

          if (comidas == null || comidas.isEmpty) {
            return const Center(
              child: Text('No hay datos'),
            ); // Mensaje si no hay registros
          }

          return ListView.builder(
            //de esta manera se ira renderizando solo lo que se ve en pantalla
            padding: const EdgeInsets.all(12.0),
            itemCount: comidas.length,
            itemBuilder: (context, index) {
              //aqui deberia empezar a dibujar
              final comida = comidas[index];
              return Card(
                child: ListTile(
                  // Item con icono, título, subtítulo y acción
                  leading: Icon(Icons.food_bank_sharp, color: colors.primary),
                  title: Text(
                    '${comida.nombre_comida}-Costo:${comida.costo_comida} Gs.',
                  ),
                  subtitle: Text('Autor:${comida.autor}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: colors.secondary),
                    onPressed: () async {
                      // Confirmación simple
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Confirmar'),
                          content: Text('Eliminar ${comida.nombre_comida}?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Eliminar'),
                            ),
                          ],
                        ),
                      );

                      if (confirm != true) return;

                      try {
                        // Lógica de DELETE separada
                        await DelCocinaRespuesta().deleteCocina(
                          comida.id_comida,
                        );
                        if (!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Comida eliminada')),
                        );

                        // Recargar lista
                        setState(() {
                          _comidasfuture = GetCocinaRespuesta().getRespuesta();
                        });
                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('Error: $e')));
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Agregar Comida',
        onPressed: ()async{
          //navegar con gorouter 
          final result = await context.push<bool>('/alta-cocina');
          if (result == true) {
            setState(() {
              _comidasfuture = GetCocinaRespuesta().getRespuesta(); // Si el formulario devolvió true, recarga la lista
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
