import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../providers/home_provider.dart';

class BannerSlider extends ConsumerStatefulWidget {
  const BannerSlider({super.key});

  @override
  ConsumerState<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends ConsumerState<BannerSlider> {
  final _pageCtrl = PageController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(seconds: AppConstants.bannerAutoPlayDuration),
          (_) {
        if (!mounted) return;
        final banners = ref.read(bannersProvider);
        final cur     = ref.read(currentBannerProvider);
        final next    = (cur + 1) % banners.length;
        ref.read(currentBannerProvider.notifier).state = next;
        if (_pageCtrl.hasClients) {
          _pageCtrl.animateToPage(
            next,
            duration: const Duration(milliseconds: 500),
            curve:    Curves.easeInOut,
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final banners      = ref.watch(bannersProvider);
    final currentIndex = ref.watch(currentBannerProvider);

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            height: 190,
            child: PageView.builder(
              controller:  _pageCtrl,
              itemCount:   banners.length,
              onPageChanged: (i) =>
              ref.read(currentBannerProvider.notifier).state = i,
              itemBuilder: (_, i) => _BannerItem(imageUrl: banners[i]),
            ),
          ),
        ),
        const SizedBox(height: 12),
        AnimatedSmoothIndicator(
          activeIndex: currentIndex,
          count:       banners.length,
          effect: const ExpandingDotsEffect(
            dotHeight:      6,
            dotWidth:       6,
            activeDotColor: AppColors.primary,
            dotColor:       AppColors.divider,
            expansionFactor: 4,
          ),
        ),
      ],
    );
  }
}

class _BannerItem extends StatelessWidget {
  final String imageUrl;
  const _BannerItem({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl:    imageUrl,
          fit:         BoxFit.cover,
          placeholder: (_, __) => Container(color: AppColors.shimmerBase),
          errorWidget: (_, __, ___) =>
              Container(color: AppColors.surfaceVariant),
        ),
        Container(
          decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        ),
        Positioned(
          bottom: 20,
          left:   20,
          right:  80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color:        AppColors.primary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'LIMITED OFFER',
                  style: AppTextStyles.labelSmall
                      .copyWith(color: Colors.white),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Up to 30% Off',
                style: AppTextStyles.headlineMedium
                    .copyWith(color: Colors.white),
              ),
              const SizedBox(height: 3),
              Text(
                'On your first order today',
                style: AppTextStyles.bodySmall
                    .copyWith(color: Colors.white70),
              ),
            ],
          ),
        ),
      ],
    );
  }
}