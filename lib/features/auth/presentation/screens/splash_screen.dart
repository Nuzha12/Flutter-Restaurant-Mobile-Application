import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../providers/auth_provider.dart';
import '../../providers/auth_state.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _scaleAnim = Tween<double>(begin: 0.7, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    _ctrl.forward();

    Future.delayed(const Duration(seconds: AppConstants.splashDuration + 1), () {
      if (mounted) {
        final authState = ref.read(authProvider);
        if (authState.status == AuthStatus.authenticated) {
          context.go(RouteNames.main);
        } else {
          context.go(RouteNames.login);
        }
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: ScaleTransition(
              scale: _scaleAnim,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: const Icon(Icons.restaurant_rounded,
                        color: Colors.white, size: 56),
                  ),
                  const SizedBox(height: 20),
                  Text(AppConstants.appName,
                      style: AppTextStyles.displayLarge.copyWith(
                          color: Colors.white, letterSpacing: 1.5)),
                  const SizedBox(height: 8),
                  Text(AppConstants.appTagline,
                      style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white.withOpacity(0.85))),
                  const SizedBox(height: 60),
                  const CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}