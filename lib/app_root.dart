import 'package:flutter/material.dart';
import 'package:hoteque_app/core/provider/auth_provider.dart';
import 'package:hoteque_app/core/routes/my_route_delegate.dart';
import 'package:hoteque_app/my_app.dart';
import 'package:http/http.dart' as http;
import 'package:hoteque_app/core/data/networking/service/api_services.dart';
import 'package:hoteque_app/core/data/repository/auth_repository.dart';
import 'package:hoteque_app/core/routes/my_route_information_parser.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRoot extends StatelessWidget {
  final SharedPreferences sharedPrefs;

  const AppRoot({super.key, required this.sharedPrefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => MyRouteInformationParser()),
        Provider(create: (_) => ApiServices(httpClient: http.Client())),
        Provider(
          create:
              (context) =>
                  AuthRepository(sharedPrefs, context.read<ApiServices>()),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(context.read<AuthRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) => MyRouteDelegate(context.read<AuthProvider>()),
        ),
      ],
      child: MyApp(),
    );
  }
}
