import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'services/auth_service.dart';

void main() {
  final authService = AuthService();
  final router = AppRouter.create(authService);

  runApp(
    ChangeNotifierProvider<AuthService>.value(
      value: authService,
      child: AbmsApp(router: router),
    ),
  );
}
