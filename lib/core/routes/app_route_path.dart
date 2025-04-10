class AppRoutePath {
  final bool isRegisterScreen;
  final bool isLoginScreen;
  final bool isMainScreen;
  final bool isUnknown;
  final int? tabIndex;

  AppRoutePath.register()
    : isRegisterScreen = true,
      isLoginScreen = false,
      isMainScreen = false,
      isUnknown = false,
      tabIndex = null;

  AppRoutePath.login()
    : isRegisterScreen = false,
      isLoginScreen = true,
      isMainScreen = false,
      isUnknown = false,
      tabIndex = null;

  AppRoutePath.home({this.tabIndex = 0})
    : isRegisterScreen = false,
      isLoginScreen = false,
      isMainScreen = true,
      isUnknown = false;

  AppRoutePath.unknown()
    : isRegisterScreen = false,
      isLoginScreen = false,
      isMainScreen = false,
      isUnknown = true,
      tabIndex = null;
}
