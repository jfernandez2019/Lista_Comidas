import 'package:flutter/material.dart'; // Flutter UI toolkit
import 'package:lista_comida/entities/comidas.dart'; // Entidad de dominio 'Libros'
import 'package:lista_comida/helpers/post_comida.dart'; // Servicio para crear (POST) un libro en la API

class AddCocina extends StatefulWidget { // Widget con estado para el formulario de alta
  const AddCocina({super.key}); // Constructor const

  @override
  State<AddCocina> createState() => _AddCocinaState(); // Crea el estado asociado
}

class _AddCocinaState extends State<AddCocina> { // Estado del formulario de alta
  final _formKey = GlobalKey<FormState>(); // Key para validar el formulario
  final _idController = TextEditingController(); // Controller para el campo 'Título'
  final _nombreController = TextEditingController(); // Controller para el campo 'Título'
  final _autorController = TextEditingController(); // Controller para el campo 'Autor'
  final _costoController = TextEditingController(); // Controller para el campo 'Género'
  final _service = PostLibroService(); // Servicio que realiza el POST al backend

  bool _isSubmitting = false; // Indica si se está enviando el formulario (estado de carga)

  @override
  void dispose() { // Limpia los controllers cuando el widget se destruye
     _idController.dispose();
    _nombreController.dispose();
    _autorController.dispose();
    _costoController.dispose();
    super.dispose();
  }

  Future<void> _submit() async { // Función que valida y envía el formulario
    if (!_formKey.currentState!.validate()) return; // Si falla validación, salir

    setState(() => _isSubmitting = true); // Marca inicio de envío

    // No enviamos id porque es autoincremental en la base de datos.
    final comidas = Comidas(
      id_comida    : _idController.text.trim(), // id vacío para que el backend asigne autoincrement
      nombre_comida: _nombreController.text.trim(), // Toma el texto del controller
      autor        : _autorController.text.trim(),
      costo_comida : _costoController.text.trim(),
    );

    try {
      final ok = await _service.createComida(comidas); // Llama al servicio POST
      if (ok) {
        if (!mounted) return; // Protege el uso del context si el widget fue desmontado
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comida creada correctamente')), // Mensaje de éxito
        );
        // Devolver true al cerrar para indicar al HomeScreen que debe refrescar
        Navigator.of(context).pop(true);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al crear el Comida')), // Mensaje si la API respondió con error
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Excepción: $e')), // Muestra la excepción capturada
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false); // Restablece estado de envío
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alta de Comida')), // Barra superior con título
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Espaciado interno alrededor del formulario
        child: Form(
          key: _formKey, // Asocia la key para validación
          child: SingleChildScrollView( // Permite scroll si el teclado ocupa espacio
            child: Column(
              children: [
                const SizedBox(height: 12), // Separador pequeño
                TextFormField(
                  controller: _idController, // Campo 'Id'
                  decoration: const InputDecoration(labelText: 'Id'), // Etiqueta visible
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingrese el Identificador' : null, // Validación simple
                ),
                const SizedBox(height: 6), // Separador pequeño
                TextFormField(
                  controller: _nombreController, // Campo 'Título'
                  decoration: const InputDecoration(labelText: 'Título'), // Etiqueta visible
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingrese el título' : null, // Validación simple
                ),
                const SizedBox(height: 12), // Espacio vertical
                TextFormField(
                  controller: _autorController, // Campo 'Autor'
                  decoration: const InputDecoration(labelText: 'Autor'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingrese el autor' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _costoController, // Campo 'Costo'
                  decoration: const InputDecoration(labelText: 'Costo'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingrese el costo' : null,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity, // Botón ocupa todo el ancho disponible
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submit, // Disabled mientras se envía
                    child: _isSubmitting
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) // Indicador en botón
                        : const Text('Crear Costo'), // Texto del botón
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}