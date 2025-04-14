class AppRoutePath {
  final bool isWelcomeScreen;
  final bool isRegisterScreen;
  final bool isLoginScreen;
  final bool isMainScreen;
  final bool isUnknown;
  final int? tabIndex;

  AppRoutePath.welcome()
    : isWelcomeScreen = true,
      isLoginScreen = false,
      isRegisterScreen = false,
      isMainScreen = false,
      isUnknown = false,
      tabIndex = null;

  AppRoutePath.register()
    : isWelcomeScreen = false,
      isRegisterScreen = true,
      isLoginScreen = false,
      isMainScreen = false,
      isUnknown = false,
      tabIndex = null;

  AppRoutePath.login()
    : isWelcomeScreen = false,
      isLoginScreen = true,
      isRegisterScreen = false,
      isMainScreen = false,
      isUnknown = false,
      tabIndex = null;

  AppRoutePath.home({this.tabIndex = 0})
    : isWelcomeScreen = false,
      isRegisterScreen = false,
      isLoginScreen = false,
      isMainScreen = true,
      isUnknown = false;

  AppRoutePath.unknown()
    : isWelcomeScreen = false,
      isRegisterScreen = false,
      isLoginScreen = false,
      isMainScreen = false,
      isUnknown = true,
      tabIndex = null;
}
