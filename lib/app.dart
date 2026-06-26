import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'services/auth_service.dart';
import 'screens/admin/admin_shell.dart';
import 'screens/auth/login_screen.dart';
import 'screens/resident/resident_shell.dart';
import 'screens/staff/staff_shell.dart';
import 'models/user_role.dart';

class AppRouter {
  static GoRouter create(AuthService authService) {
    return GoRouter(
      initialLocation: '/login',
      refreshListenable: authService,
      redirect: (context, state) {
        final isLoggedIn = authService.isLoggedIn;
        final isLoginRoute = state.matchedLocation == '/login';

        if (!isLoggedIn) {
          return isLoginRoute ? null : '/login';
        }

        if (isLoginRoute) {
          return authService.currentUser!.role.homeRoute;
        }

        final role = authService.currentUser!.role;
        final location = state.matchedLocation;

        if (role == UserRole.resident && !location.startsWith('/resident')) {
          return '/resident';
        }
        if (role == UserRole.staff && !location.startsWith('/staff')) {
          return '/staff';
        }
        if (role == UserRole.admin && !location.startsWith('/admin')) {
          return '/admin';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/resident',
          builder: (context, state) => const ResidentShell(),
        ),
        GoRoute(
          path: '/staff',
          builder: (context, state) => const StaffShell(),
        ),
        GoRoute(
          path: '/admin',
          builder: (context, state) => const AdminShell(),
        ),
      ],
    );
  }
}

class AbmsApp extends StatelessWidget {
  const AbmsApp({super.key, required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ABMS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Color(0xFFE0E0E0)),
          ),
        ),
      ),
      routerConfig: router,
    );
  }
}
