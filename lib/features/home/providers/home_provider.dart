import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/api_constants.dart';

final bannersProvider       = Provider<List<String>>((_) => ApiConstants.foodBanners);
final currentBannerProvider = StateProvider<int>((_) => 0);