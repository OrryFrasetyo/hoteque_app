import 'package:flutter/material.dart';
import 'package:hoteque_app/core/provider/auth_provider.dart';
import 'package:hoteque_app/core/routes/app_route_path.dart';
import 'package:hoteque_app/ui/auth/login_screen.dart';
import 'package:hoteque_app/ui/auth/register_screen.dart';
import 'package:hoteque_app/ui/main/main_screen.dart';
import 'package:hoteque_app/ui/profile/profile_screen.dart';
import 'package:hoteque_app/ui/walkgrouth/welcome_screen.dart';

class MyRouteDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  final GlobalKey<NavigatorState> _navigatorKey;
  final AuthProvider authProvider;
  final _mainScreenKey = GlobalKey();

  bool _isWelcomeScreen = true;
  bool _isLoginScreen = false;
  bool _isRegisterScreen = false;
  bool _isMainScreen = false;
  bool _isProfileScreen = false;
  bool _isLoggedIn = false;

  int _currentTabIndex = 0;

  MyRouteDelegate(this.authProvider)
    : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  _init() async {
    bool isFirstTime = await authProvider.isFirstLaunch();
    _isLoggedIn = await authProvider.isLogged();

    if (isFirstTime) {
      _isWelcomeScreen = true;
      _isLoginScreen = false;
      _isRegisterScreen = false;
      _isMainScreen = false;
      _isProfileScreen = false;
    } else if (_isLoggedIn) {
      _isWelcomeScreen = false;
      _isMainScreen = true;
      _isRegisterScreen = false;
      _isLoginScreen = false;
      _isProfileScreen = false;
    } else {
      // Set welcome screen sebagai layar awal jika belum login
      _isWelcomeScreen = true;
      _isRegisterScreen = false;
      _isLoginScreen = false;
      _isMainScreen = false;
      _isProfileScreen = false;
    }
    notifyListeners();
  }

  int get currentTabIndex => _currentTabIndex;

  set currentTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  AppRoutePath get currentConfiguration {
    if (_isProfileScreen) {
      return AppRoutePath.profile();
    } else if (_isLoggedIn && _isMainScreen) {
      return AppRoutePath.home(tabIndex: _currentTabIndex);
    } else if (_isWelcomeScreen) {
      return AppRoutePath.welcome();
    } else if (_isLoginScreen) {
      return AppRoutePath.login();
    } else if (_isRegisterScreen) {
      return AppRoutePath.register();
    } else {
      return AppRoutePath.unknown();
    }

    // if (_isLoggedIn) {
    //   return AppRoutePath.home(tabIndex: _currentTabIndex);
    // } else if (_isWelcomeScreen) {
    //   return AppRoutePath.welcome();
    // } else if (_isLoginScreen) {
    //   return AppRoutePath.login();
    // } else if (_isRegisterScreen) {
    //   return AppRoutePath.register();
    // } else {
    //   return AppRoutePath.unknown();
    // }
  }

  @override
  Future<bool> popRoute() async {

    // Jika di halaman profile, kembali ke main screen
    if (_isProfileScreen) {
      _isProfileScreen = false;
      _isMainScreen = true;
      notifyListeners();
      return true;
    }

    // back button behavior after logged in
    if (_isLoggedIn && _isMainScreen) {
      // If we're not on the first tab, go back to first tab instead of exiting
      if (_currentTabIndex != 0) {
        _currentTabIndex = 0;
        notifyListeners();
        return true;
      }
      return false;
    }

    // if on register screen, go back to login screen
    if (_isRegisterScreen) {
      _isRegisterScreen = false;
      _isLoginScreen = true;
      notifyListeners();
      return true;
    }
    
    return false;
  }

  void navigateToHome({int tabIndex = 0}) {
    _currentTabIndex = tabIndex;
    _isWelcomeScreen = false;
    _isLoginScreen = false;
    _isRegisterScreen = false;
    _isMainScreen = true;
    _isProfileScreen = false;
    notifyListeners();
  }

  // Menambahkan method untuk navigasi ke profile screen
  void navigateToProfile() {
    _isProfileScreen = true;
    _isMainScreen = false;
    _isWelcomeScreen = false;
    _isLoginScreen = false;
    _isRegisterScreen = false;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    bool isCurrentLoggedIn = authProvider.isLoggedIn;

    // if login status changed, update our local state
    if (isCurrentLoggedIn != _isLoggedIn) {
      _isLoggedIn = isCurrentLoggedIn;
      if (_isLoggedIn) {
        _isMainScreen = true;
        _isWelcomeScreen = false;
        _isLoginScreen = false;
        _isRegisterScreen = false;
        _isProfileScreen = false;
      } else {
        _isWelcomeScreen = true;
        _isLoginScreen = false;
        _isRegisterScreen = false;
        _isMainScreen = false;
        _isProfileScreen = false;
      }
    }

    return Navigator(
      key: navigatorKey,
      pages: [
        if (_isWelcomeScreen)
          MaterialPage(
            key: ValueKey("WelcomeScreen"),
            child: WelcomeScreen(
              onGetStarted: () async {
                await authProvider.markFirstLaunchComplete();
                _isLoginScreen = true;
                _isWelcomeScreen = false;
                notifyListeners();
              },
            ),
          ),

        if (_isLoginScreen)
          MaterialPage(
            key: ValueKey("LoginScreen"),
            child: LoginScreen(
              onLogin: () {
                _isLoggedIn = true;
                _isMainScreen = true;
                _isLoginScreen = false;
                notifyListeners();
              },
              onRegister: () {
                _isRegisterScreen = true;
                _isLoginScreen = false;
                notifyListeners();
              },
            ),
          ),

        if (_isRegisterScreen)
          MaterialPage(
            key: ValueKey("RegisterScreen"),
            child: RegisterScreen(
              onRegister: () {
                _isLoggedIn = true;
                _isMainScreen = true;
                _isRegisterScreen = false;
                notifyListeners();
              },
              onLogin: () {
                _isLoginScreen = true;
                _isRegisterScreen = false;
                notifyListeners();
              },
            ),
          ),

        if (_isMainScreen)
          MaterialPage(
            key: ValueKey("MainScreen"),
            child: MainScreen(
              key: _mainScreenKey,
              onLogout: () {
                _isLoggedIn = false;
                _isMainScreen = false;
                _isWelcomeScreen = true;
                _currentTabIndex = 0; // reset tab index on logout
                notifyListeners();
              },
              currentIndex: _currentTabIndex,
              onTabChanged: (index) {
                _currentTabIndex = index;
                notifyListeners();
              },
            ),
          ),

          // Tambahkan halaman profile jika isProfileScreen true
        if (_isProfileScreen)
          MaterialPage(
            key: ValueKey("ProfileScreen"),
            child: ProfileScreen(
              onBack: () {
                _isProfileScreen = false;
                _isMainScreen = true;
                notifyListeners();
              },
            ),
          ),
      ],
      onDidRemovePage: (page) {
        if (page.key == ValueKey("RegisterPage")) {
          _isRegisterScreen = false;
          _isLoginScreen = true;
          notifyListeners();
        }
      },
    );
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath path) async {
    if (path.isUnknown) {
      _isWelcomeScreen = false;
      _isLoginScreen = true;
      _isRegisterScreen = false;
      _isMainScreen = false;
      _isProfileScreen = false;
      _isLoggedIn = false;
      return;
    }

    // tambahin kodenya nanti ya
    if (path.isWelcomeScreen) {
      _isWelcomeScreen = true;
      _isLoginScreen = false;
      _isRegisterScreen = false;
      _isMainScreen = false;
      _isProfileScreen = false;
      _isLoggedIn = false;
      return;
    } else if (path.isLoginScreen) {
      _isWelcomeScreen = false;
      _isLoginScreen = true;
      _isRegisterScreen = false;
      _isMainScreen = false;
      _isProfileScreen = false;
      _isLoggedIn = false;
    } else if (path.isRegisterScreen) {
      _isWelcomeScreen = false;
      _isLoginScreen = false;
      _isRegisterScreen = true;
      _isMainScreen = false;
      _isProfileScreen = false;
      _isLoggedIn = false;
    } else if (path.isMainScreen) {
      if (_isLoggedIn) {
        _isWelcomeScreen = false;
        _isLoginScreen = false;
        _isRegisterScreen = false;
        _isMainScreen = true;
        _isProfileScreen = false;

        if (path.tabIndex != null) {
          _currentTabIndex = path.tabIndex!;
        }
      } else {
        // if not logged in, go to welcome screen
        _isWelcomeScreen = true;
        _isLoginScreen = false;
        _isRegisterScreen = false;
        _isMainScreen = false;
      }
    } else if (path.isProfileScreen) {
      if (_isLoggedIn) {
        _isWelcomeScreen = false;
        _isLoginScreen = false;
        _isRegisterScreen = false;
        _isMainScreen = false;
        _isProfileScreen = true;
      } else {
        // if not logged in, go to welcome screen
        _isWelcomeScreen = true;
        _isLoginScreen = false;
        _isRegisterScreen = false;
        _isMainScreen = false;
        _isProfileScreen = false;
      }
    }
  }
}
