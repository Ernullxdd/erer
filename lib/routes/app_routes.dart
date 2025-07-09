import 'package:flutter/material.dart';
import '../presentation/token_authentication_screen/token_authentication_screen.dart';
import '../presentation/web_view_screen/web_view_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String tokenAuthenticationScreen =
      '/token-authentication-screen';
  static const String webViewScreen = '/web-view-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => TokenAuthenticationScreen(),
    tokenAuthenticationScreen: (context) => TokenAuthenticationScreen(),
    webViewScreen: (context) => WebViewScreen(),
    // TODO: Add your other routes here
  };
}
