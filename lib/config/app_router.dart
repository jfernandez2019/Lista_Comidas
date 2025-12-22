import 'package:go_router/go_router.dart'; // armar rutas en dart/flutter
import 'package:lista_comida/screens/alta-cocina.dart';
import 'package:lista_comida/screens/home_screen.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => HomeScreen()),
    GoRoute(path: '/alta-cocina', builder: (context, state) => AddCocina()),
  ],
);
