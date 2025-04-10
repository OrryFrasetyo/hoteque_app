import 'package:flutter/material.dart';
import 'package:hoteque_app/core/routes/app_route_path.dart';

class MyRouteDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
      
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  @override
  // TODO: implement navigatorKey
  GlobalKey<NavigatorState>? get navigatorKey => throw UnimplementedError();

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) {
    // TODO: implement setNewRoutePath
    throw UnimplementedError();
  }
}
