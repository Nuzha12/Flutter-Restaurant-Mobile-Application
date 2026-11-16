class AppConstants {
  AppConstants._();

  static const String appName          = 'Savoria';
  static const String appTagline       = 'Fine dining, delivered';
  static const String appVersion       = '2.0.0';

  static const String sampleEmail    = 'user@savoria.com';
  static const String samplePassword = 'password123';

  static const double defaultPadding   = 16.0;
  static const double largePadding     = 24.0;
  static const double smallPadding     = 8.0;
  static const double cardRadius       = 20.0;
  static const double buttonRadius     = 16.0;
  static const double inputRadius      = 14.0;
  static const double chipRadius       = 24.0;

  static const double deliveryFee             = 2.99;
  static const double taxRate                 = 0.08;
  static const double freeDeliveryThreshold  = 30.0;
  static const double minOrderAmount          = 10.0;

  static const int splashDuration          = 2;
  static const int bannerAutoPlayDuration  = 4;
  static const int searchDebounceMs        = 400;
  static const int animationDurationMs     = 300;
  static const int pageTransitionMs        = 350;

  static const String currencySymbol = '\$';
  static const String distanceUnit   = 'km';
  static const String timeUnit       = 'min';

  static const int maxCartItemQuantity = 20;
  static const int maxSpecialInstLen   = 200;

  static const List<String> dietaryFilters = [
    'All', 'Vegetarian', 'Vegan', 'Gluten Free', 'Spicy'
  ];

  static const List<String> sortOptions = [
    'Popular', 'Price: Low to High', 'Price: High to Low',
    'Rating', 'Prep Time'
  ];
}