import 'package:flutter/material.dart';
import 'package:hoteque_app/core/data/repository/position_repository.dart';
import 'package:hoteque_app/core/data/repository/profile_repository.dart';
import 'package:hoteque_app/core/data/repository/schedule_repository.dart';
import 'package:hoteque_app/core/provider/auth_provider.dart';
import 'package:hoteque_app/core/provider/position_provider.dart';
import 'package:hoteque_app/core/provider/profile_provider.dart';
import 'package:hoteque_app/core/provider/schedule_department_provider.dart';
import 'package:hoteque_app/core/provider/schedule_employee_provider.dart';
import 'package:hoteque_app/core/provider/schedule_now_provider.dart';
import 'package:hoteque_app/core/provider/time_provider.dart';
import 'package:hoteque_app/core/provider/update_profile_provider.dart';
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
        Provider(
          create: (context) => PositionRepository(context.read<ApiServices>()),
        ),
        Provider(
          create: (context) => ProfileRepository(context.read<ApiServices>()),
        ),
        Provider(
          create: (context) => ScheduleRepository(context.read<ApiServices>()),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(context.read<AuthRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) => MyRouteDelegate(context.read<AuthProvider>()),
        ),
        ChangeNotifierProvider(
          create:
              (context) => PositionProvider(context.read<PositionRepository>()),
        ),
        ChangeNotifierProvider(
          create:
              (context) =>
                  ScheduleNowProvider(context.read<ScheduleRepository>()),
        ),
        ChangeNotifierProvider(
          create: (_) => TimeProvider(),
          ),
        ChangeNotifierProvider(
          create:
              (context) => ProfileProvider(context.read<ProfileRepository>()),
        ),
        ChangeNotifierProvider(
          create:
              (context) =>
                  UpdateProfileProvider(context.read<ProfileRepository>()),
        ),
        ChangeNotifierProvider(
          create:
              (context) =>
                  ScheduleEmployeeProvider(context.read<ScheduleRepository>()),
        ),
        ChangeNotifierProvider(
          create:
              (context) => ScheduleDepartmentProvider(
                context.read<ScheduleRepository>(),
              ),
        ),
      ],
      child: MyApp(),
    );
  }
}
