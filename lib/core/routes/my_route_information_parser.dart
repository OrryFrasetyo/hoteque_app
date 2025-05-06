import 'package:flutter/material.dart';
import 'package:hoteque_app/core/routes/app_route_path.dart';

class MyRouteInformationParser extends RouteInformationParser<AppRoutePath> {
  @override
  Future<AppRoutePath> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = Uri.parse(routeInformation.uri.toString());

    if (uri.pathSegments.isEmpty) {
      return AppRoutePath.home();
    }

    if (uri.pathSegments.first == 'welcome') {
      return AppRoutePath.welcome();
    }

    if (uri.pathSegments.first == 'login') {
      return AppRoutePath.login();
    }

    if (uri.pathSegments.first == 'register') {
      return AppRoutePath.register();
    }

    if (uri.pathSegments.first == 'home') {
      return AppRoutePath.home();
    }

    if (uri.pathSegments.first == 'schedule') {
      return AppRoutePath.home(tabIndex: 1);
    }

    if (uri.pathSegments.first == 'task') {
      return AppRoutePath.home(tabIndex: 2);
    }

    if (uri.pathSegments.first == 'history') {
      return AppRoutePath.home(tabIndex: 3);
    }

    if (uri.pathSegments.first == 'profile') {
      return AppRoutePath.profile();
    }

    if (uri.pathSegments.first == 'edit_profile') {
      return AppRoutePath.editProfile();
    }

    if (uri.pathSegments.first == 'schedule_employee') {
      return AppRoutePath.scheduleEmployee();
    }

    return AppRoutePath.unknown();
  }

  @override
  RouteInformation? restoreRouteInformation(AppRoutePath configuration) {
    if (configuration.isUnknown) {
      return RouteInformation(uri: Uri.parse("/unknown"));
    }

    if (configuration.isWelcomeScreen) {
      return RouteInformation(uri: Uri.parse("/welcome"));
    }

    if (configuration.isRegisterScreen) {
      return RouteInformation(uri: Uri.parse("/register"));
    }

    if (configuration.isLoginScreen) {
      return RouteInformation(uri: Uri.parse("/login"));
    }

    if (configuration.isMainScreen) {
      final tabIndex = configuration.tabIndex ?? 0;
      if (tabIndex == 0) {
        return RouteInformation(uri: Uri.parse("/home"));
      }

      if (tabIndex == 1) {
        return RouteInformation(uri: Uri.parse("/schedule"));
      }

      if (tabIndex == 2) {
        return RouteInformation(uri: Uri.parse("/task"));
      }

      if (tabIndex == 3) {
        return RouteInformation(uri: Uri.parse("/history"));
      }
    }

    if (configuration.isProfileScreen) {
      return RouteInformation(uri: Uri.parse("/profile"));
    }

    if (configuration.isEditProfileScreen) {
      return RouteInformation(uri: Uri.parse("/edit_profile"));
    }

    if (configuration.isScheduleEmployeeScreen) {
      return RouteInformation(uri: Uri.parse("/schedule_employee"));
    }

    return RouteInformation(uri: Uri.parse("/"));
  }
}
