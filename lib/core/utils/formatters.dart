import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static String currency(double v)       => '\$${v.toStringAsFixed(2)}';
  static String date(DateTime d)         => DateFormat('MMM dd, yyyy').format(d);
  static String dateShort(DateTime d)    => DateFormat('MMM dd').format(d);
  static String dateTime(DateTime d)     => DateFormat('MMM dd, yyyy • hh:mm a').format(d);
  static String time(DateTime d)         => DateFormat('hh:mm a').format(d);
  static String minutesToReady(int m)    => m < 60 ? '$m min' : '${m ~/ 60}h ${m % 60}m';
  static String distance(double km)      => '${km.toStringAsFixed(1)} km';
  static String rating(double r)         => r.toStringAsFixed(1);
  static String relativeTime(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inMinutes < 1)  return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours   < 24) return '${diff.inHours}h ago';
    if (diff.inDays    < 7)  return '${diff.inDays}d ago';
    return date(d);
  }
  static String itemCount(int n) => n == 1 ? '1 item' : '$n items';

  // Both names supported — orderNo is canonical, orderNumber is alias
  static String orderNo(String id) {
    final trimmed = id.length > 8 ? id.substring(id.length - 8) : id;
    return '#${trimmed.toUpperCase()}';
  }

  // Alias kept for backward compatibility
  static String orderNumber(String id) => orderNo(id);
}