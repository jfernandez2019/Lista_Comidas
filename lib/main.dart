import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'package:lista_comida/config/app_router.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router( // MaterialApp configurado para usar un enrutador declarativo
      debugShowCheckedModeBanner: false, // Oculta la etiqueta de debug en la app
      title: 'Lista-Cocina', // Título de la app (usado por el sistema en algunas plataformas)
      theme: AppTheme(selectedColor: 0).getTheme(), // Aplica el tema customizado retornado por AppTheme
      routerConfig: appRouter // Provee la configuración de rutas (navegación) definida en app_router
    );
  }

}
