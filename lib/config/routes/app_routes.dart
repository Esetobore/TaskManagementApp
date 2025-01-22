import 'package:dufil/presentation/navigation/bottom_navigation.dart';
import 'package:dufil/presentation/screens/auth/login_screen.dart';
import 'package:dufil/presentation/screens/auth/signup_screen.dart';
import 'package:dufil/presentation/screens/profile/profile_screen.dart';
import 'package:dufil/presentation/screens/statistics/statistics_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const login = '/login';
  static const signup = '/signup';
  static const statistics = '/statistics';
  static const profile = '/profile';
  static const mainNavRoute = '/main';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (_) => const LoginScreen(),
      signup: (_) => const SignupScreen(),
      statistics: (_) => const StatisticsScreen(),
      profile: (_) => const ProfileScreen(),
      mainNavRoute: (_) => const MainScreenRoute(),
    };
  }
}
