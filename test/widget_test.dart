import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:prjprm393/app.dart';
import 'package:prjprm393/services/auth_service.dart';

void main() {
  testWidgets('Login screen shows ABMS title', (WidgetTester tester) async {
    final authService = AuthService();
    final router = AppRouter.create(authService);

    await tester.pumpWidget(
      ChangeNotifierProvider<AuthService>.value(
        value: authService,
        child: AbmsApp(router: router),
      ),
    );

    expect(find.text('ABMS'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
