import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:project/core/services/injection_container.dart';
import 'package:project/main.dart';

void main() {
  tearDown(() async {
    await GetIt.instance.reset();
  });

  testWidgets('MyApp builds with mocked HTTP client', (tester) async {
    WidgetsFlutterBinding.ensureInitialized();

    final client = MockClient((request) async {
      if (request.url.path.endsWith('/users') && request.method == 'GET') {
        return http.Response('[]', 200);
      }
      return http.Response('Not found', 404);
    });

    await init(httpClient: client);
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
