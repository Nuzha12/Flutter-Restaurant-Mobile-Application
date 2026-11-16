import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/menu_item_model.dart';
import '../../domain/models/order_model.dart';

import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/providers/auth_provider.dart';

import '../../features/home/presentation/screens/main_screen.dart';

import '../../features/menu/presentation/screens/menu_screen.dart';
import '../../features/menu/presentation/screens/item_detail_screen.dart';
import '../../features/menu/presentation/screens/search_screen.dart';

import '../../features/cart/presentation/screens/cart_screen.dart';
import '../../features/cart/presentation/screens/checkout_screen.dart';

import '../../features/orders/presentation/screens/orders_screen.dart';
import '../../features/orders/presentation/screens/order_detail_screen.dart';
import '../../features/orders/presentation/screens/order_tracking_screen.dart';
import '../../features/orders/presentation/screens/order_success_screen.dart';

import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/addresses_screen.dart';
import '../../features/profile/presentation/screens/add_address_screen.dart';
import '../../features/profile/presentation/screens/settings_screen.dart';
import '../../features/profile/presentation/screens/notifications_screen.dart';

import '../../features/loyalty/presentation/screens/loyalty_screen.dart';

import 'route_names.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteNames.splash,
    refreshListenable: authListenable,
    redirect: (context, state) {
      final auth = ref.read(authProvider);
      final isAuthed = auth.isAuthenticated;
      final loc = state.matchedLocation;

      final authRoutes = <String>{
        RouteNames.login,
        RouteNames.register,
        RouteNames.forgotPassword,
        RouteNames.splash,
        RouteNames.onboarding,
      };

      if (!isAuthed && !authRoutes.contains(loc)) {
        return RouteNames.login;
      }

      if (isAuthed && loc == RouteNames.login) {
        return RouteNames.main;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: RouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: RouteNames.main,
        builder: (context, state) => const MainScreen(),
      ),

      // ✅ This was missing. This fixes: no routes for location: /menu
      GoRoute(
        path: RouteNames.menu,
        builder: (context, state) => const MenuScreen(),
      ),

      GoRoute(
        path: RouteNames.itemDetail,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is! MenuItemModel) {
            return const _InvalidRouteScreen(
              message: 'Invalid menu item data.',
            );
          }
          return ItemDetailScreen(item: extra);
        },
      ),
      GoRoute(
        path: RouteNames.search,
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: RouteNames.cart,
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: RouteNames.checkout,
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: RouteNames.orderSuccess,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is! OrderModel) {
            return const _InvalidRouteScreen(
              message: 'Invalid order success data.',
            );
          }
          return OrderSuccessScreen(order: extra);
        },
      ),
      GoRoute(
        path: RouteNames.orders,
        builder: (context, state) => const OrdersScreen(),
      ),
      GoRoute(
        path: RouteNames.orderDetail,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is! OrderModel) {
            return const _InvalidRouteScreen(
              message: 'Invalid order detail data.',
            );
          }
          return OrderDetailScreen(order: extra);
        },
      ),
      GoRoute(
        path: RouteNames.orderTracking,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is! OrderModel) {
            return const _InvalidRouteScreen(
              message: 'Invalid order tracking data.',
            );
          }
          return OrderTrackingScreen(order: extra);
        },
      ),
      GoRoute(
        path: RouteNames.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.addresses,
        builder: (context, state) => const AddressesScreen(),
      ),
      GoRoute(
        path: RouteNames.addAddress,
        builder: (context, state) => const AddAddressScreen(),
      ),
      GoRoute(
        path: RouteNames.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: RouteNames.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: RouteNames.loyalty,
        builder: (context, state) => const LoyaltyScreen(),
      ),
    ],
    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(
          child: Text('Page not found: ${state.error}'),
        ),
      );
    },
  );
});

class _InvalidRouteScreen extends StatelessWidget {
  final String message;

  const _InvalidRouteScreen({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invalid Page'),
      ),
      body: Center(
        child: Text(message),
      ),
    );
  }
}