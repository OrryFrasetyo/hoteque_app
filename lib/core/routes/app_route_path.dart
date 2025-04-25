class AppRoutePath {
  final bool isWelcomeScreen;
  final bool isRegisterScreen;
  final bool isLoginScreen;
  final bool isMainScreen;
  final bool isUnknown;
  final int? tabIndex;
  final bool isProfileScreen;
  final bool isEditProfileScreen;

  AppRoutePath.welcome()
    : isWelcomeScreen = true,
      isLoginScreen = false,
      isRegisterScreen = false,
      isMainScreen = false,
      isProfileScreen = false,
      isEditProfileScreen = false,
      isUnknown = false,
      tabIndex = null;

  AppRoutePath.register()
    : isWelcomeScreen = false,
      isRegisterScreen = true,
      isLoginScreen = false,
      isMainScreen = false,
      isProfileScreen = false,
      isEditProfileScreen = false,
      isUnknown = false,
      tabIndex = null;

  AppRoutePath.login()
    : isWelcomeScreen = false,
      isLoginScreen = true,
      isRegisterScreen = false,
      isMainScreen = false,
      isProfileScreen = false,
      isEditProfileScreen = false,
      isUnknown = false,
      tabIndex = null;

  AppRoutePath.home({this.tabIndex = 0})
    : isWelcomeScreen = false,
      isRegisterScreen = false,
      isLoginScreen = false,
      isMainScreen = true,
      isProfileScreen = false,
      isEditProfileScreen = false,
      isUnknown = false;

  AppRoutePath.unknown()
    : isWelcomeScreen = false,
      isRegisterScreen = false,
      isLoginScreen = false,
      isMainScreen = false,
      isProfileScreen = false,
      isEditProfileScreen = false,
      isUnknown = true,
      tabIndex = null;

  AppRoutePath.profile()
    : isWelcomeScreen = false,
      isRegisterScreen = false,
      isLoginScreen = false,
      isMainScreen = false,
      isProfileScreen = true,
      isEditProfileScreen = false,
      isUnknown = false,
      tabIndex = null;

  AppRoutePath.editProfile()
    : isWelcomeScreen = false,
      isRegisterScreen = false,
      isLoginScreen = false,
      isMainScreen = false,
      isProfileScreen = false,
      isEditProfileScreen = true,
      isUnknown = false,
      tabIndex = null;
}
