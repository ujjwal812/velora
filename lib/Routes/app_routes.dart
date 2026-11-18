import 'package:flutter/material.dart';


import '../Nav_Button/bottom_nav.dart';
import '../Onboading_/SigIn_screen.dart';
import '../Onboading_/forgot_screen.dart';
import '../Onboading_/login_screen.dart';
import '../Onboading_/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signIn = '/sign-in';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';

  static Map<String, WidgetBuilder> get routes => {
        splash: (context) => const SplashScreen(),
        login: (context) => const LoginScreen(),
        signIn: (context) => const SignInScreen(),
        forgotPassword: (context) => const ForgotScreen(),
        home: (context) => const MainBottomNav(),
      };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
      case signIn:
        return MaterialPageRoute(
          builder: (_) => const SignInScreen(),
          settings: settings,
        );
      case forgotPassword:
        return MaterialPageRoute(
          builder: (_) => const ForgotScreen(),
          settings: settings,
        );
      case home:
        return MaterialPageRoute(
          builder: (_) => const MainBottomNav(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
          settings: settings,
        );
    }
  }
}
