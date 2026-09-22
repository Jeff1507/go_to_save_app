import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:go_to_save_app/core/auth/auth_provider.dart';
import 'package:go_to_save_app/core/auth/auth_status.dart';
import 'package:go_to_save_app/core/router/router_refresh_notifier.dart';
import 'package:go_to_save_app/features/auth/screens/login_screen.dart';
import 'package:go_to_save_app/features/auth/screens/request_password_reset_screen.dart';
import 'package:go_to_save_app/features/auth/screens/reset_password_screen.dart';
import 'package:go_to_save_app/features/auth/screens/signup_screen.dart';
import 'package:go_to_save_app/features/home/screens/home_screen.dart';
import 'package:go_to_save_app/features/profile/screens/update_email_screen.dart';
import 'package:go_to_save_app/features/profile/screens/update_password_screen.dart';
import 'package:go_to_save_app/features/profile/screens/update_profile_screen.dart';
import 'package:go_to_save_app/features/profile/screens/profile_screen.dart';
import 'package:go_to_save_app/shared/widgets/app_navigation_shell.dart';
import 'package:go_to_save_app/shared/screens/error_screen.dart';
import 'package:go_to_save_app/shared/screens/splash_screen.dart';
import 'package:go_to_save_app/features/auth/screens/verify_email_screen.dart';

class AppRoutes {
  static const splash = '/splash';
  static const error = '/error';
  static const signup = '/signup';
  static const login = '/login';
  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';

  static const home = '/home';
  static const search = '/search';
  static const orders = '/orders';
  static const profile = '/profile';
  static const updateProfile = '/update-profile';
  static const updateEmail = '/update-email';
  static const verifyEmail = '/verify-email';
  static const updatePassword = '/update-password';

  // Rotas que não exigem autenticação
  static const publicPaths = [signup, login, forgotPassword, resetPassword];
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: RouterRefreshNotifier(ref, authStateProvider),
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      final isSplash = state.matchedLocation == AppRoutes.splash;
      final isPublicRoute = AppRoutes.publicPaths.contains(
        state.matchedLocation,
      );

      if (authState.status == AuthStatus.unknown) {
        return isSplash ? null : AppRoutes.splash;
      }

      if (authState.status == AuthStatus.error) {
        return state.matchedLocation == AppRoutes.error
            ? null
            : AppRoutes.error;
      }

      final authenticated = authState.status == AuthStatus.authenticated;

      if (isSplash) {
        return authenticated ? AppRoutes.home : AppRoutes.login;
      }

      if (!authenticated && !isPublicRoute) {
        return AppRoutes.login;
      }

      if (authenticated && isPublicRoute) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.error,
        builder: (context, state) => const ErrorScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const RequestPasswordResetScreen(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) {
          final email = state.extra as String?;
          if (email == null) {
            return const RequestPasswordResetScreen();
          }

          return ResetPasswordScreen(email: email);
        },
      ),

      GoRoute(
        path: AppRoutes.updateProfile,
        builder: (context, state) => const UpdateProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.updateEmail,
        builder: (context, state) => const UpdateEmailScreen(),
      ),
      GoRoute(
        path: AppRoutes.verifyEmail,
        builder: (context, state) => const VerifyEmailScreen(),
      ),
      GoRoute(
        path: AppRoutes.updatePassword,
        builder: (context, state) => const UpdatePasswordScreen(),
      ),

      StatefulShellRoute.indexedStack(
        builder: (_, _, navigationShell) {
          return AppNavigationShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.search,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.orders,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
