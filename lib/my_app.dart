import 'package:flutter/material.dart';
import 'package:hoteque_app/core/routes/my_route_delegate.dart';
import 'package:hoteque_app/core/routes/my_route_information_parser.dart';
import 'package:hoteque_app/core/style/theme.dart';
import 'package:hoteque_app/core/style/util.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context);
    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp.router(
      title: "Hotelque",
      theme: theme.lightWithCustomStyles(),
      debugShowCheckedModeBanner: false,
      routeInformationParser: context.read<MyRouteInformationParser>(),
      routerDelegate: context.read<MyRouteDelegate>(),
    );
  }
}
