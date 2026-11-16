import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _ctrl = PageController();
  int _page = 0;

  static const _pages = [
    _Page(emoji: '🍔', title: 'Crave It,\nOrder It', subtitle: 'Explore hundreds of dishes from top local restaurants. Fresh, fast, and always delicious.', color: Color(0xFFE63946)),
    _Page(emoji: '⚡', title: 'Lightning\nFast Delivery', subtitle: 'Real-time order tracking from kitchen to your doorstep. Average delivery in under 30 minutes.', color: Color(0xFFF4A261)),
    _Page(emoji: '🎁', title: 'Earn While\nYou Eat', subtitle: 'Collect loyalty points on every order and unlock exclusive rewards, discounts, and chef specials.', color: Color(0xFF2A9D8F)),
  ];

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _ctrl,
            itemCount: _pages.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (_, i) => _PageView(page: _pages[i]),
          ),
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 48),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: AppColors.cardShadows,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSmoothIndicator(
                    activeIndex: _page,
                    count: _pages.length,
                    effect: ExpandingDotsEffect(
                      dotHeight: 8, dotWidth: 8, expansionFactor: 3,
                      activeDotColor: _pages[_page].color,
                      dotColor: AppColors.divider,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(_pages[_page].title,
                      style: AppTextStyles.displayMedium,
                      textAlign: TextAlign.center)
                      .animate(key: ValueKey(_page)).fadeIn().slideY(begin: 0.2, duration: 300.ms),
                  const SizedBox(height: 12),
                  Text(_pages[_page].subtitle,
                      style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
                      textAlign: TextAlign.center)
                      .animate(key: ValueKey('sub$_page')).fadeIn(delay: 80.ms),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      if (_page < _pages.length - 1) ...[
                        Expanded(
                          child: AppButton(
                            label: 'Next',
                            onPressed: () => _ctrl.nextPage(duration: const Duration(milliseconds: 350), curve: Curves.easeInOut),
                          ),
                        ),
                      ] else ...[
                        Expanded(
                          child: AppButton(
                            label: 'Get Started',
                            onPressed: () => context.go(RouteNames.login),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (_page < _pages.length - 1) ...[
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => context.go(RouteNames.login),
                      child: Text('Skip', style: AppTextStyles.labelMedium.copyWith(color: AppColors.textHint)),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Page {
  final String emoji, title, subtitle;
  final Color  color;
  const _Page({required this.emoji, required this.title, required this.subtitle, required this.color});
}

class _PageView extends StatelessWidget {
  final _Page page;
  const _PageView({required this.page});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: page.color.withOpacity(0.06),
      child: Center(
        child: Text(page.emoji, style: const TextStyle(fontSize: 120))
            .animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
      ),
    );
  }
}