import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../domain/models/order_model.dart';
import '../../../cart/providers/cart_provider.dart';
import '../../../orders/providers/orders_provider.dart';
import '../widgets/order_summary_card.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});
  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  bool    _placing       = false;
  int     _paymentIndex  = 0;
  final   _promoCtrl     = TextEditingController();
  String? _promoError;

  final _methods = [
    _PM(Icons.credit_card_rounded,              'Credit/Debit Card',  '**** 4242',       PaymentMethod.card),
    _PM(Icons.money_rounded,                    'Cash on Delivery',   'Pay at door',     PaymentMethod.cash),
    _PM(Icons.account_balance_wallet_rounded,   'Digital Wallet',     'Balance: \$45.00', PaymentMethod.wallet),
  ];

  @override
  void dispose() { _promoCtrl.dispose(); super.dispose(); }

  void _applyPromo() {
    final err = ref.read(cartProvider.notifier).applyPromo(_promoCtrl.text);
    setState(() => _promoError = err);
    if (err == null) context.showSnack('Promo applied!', icon: Icons.check_circle_outline);
  }

  Future<void> _placeOrder() async {
    setState(() => _placing = true);
    final cart    = ref.read(cartProvider);
    final addr    = ref.read(selectedAddressProvider);
    final method  = _methods[_paymentIndex].method;

    final order = await ref.read(ordersProvider.notifier).placeOrder(
      items: List.from(cart.items), address: addr,
      subtotal: cart.subtotal, deliveryFee: cart.deliveryFee, tax: cart.tax,
      discount: cart.discount, total: cart.total,
      paymentMethod: method, promoCode: cart.promoCode,
    );

    if (mounted) {
      setState(() => _placing = false);
      if (order != null) {
        ref.read(cartProvider.notifier).clearCart();
        context.go(RouteNames.orderSuccess, extra: order);
      } else {
        context.showSnack('Failed to place order. Try again.', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart    = ref.watch(cartProvider);
    final address = ref.watch(selectedAddressProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionCard(
            title: 'Deliver to',
            action: TextButton(
              onPressed: () => context.push(RouteNames.addresses),
              child: const Text('Change'),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(address.label, style: AppTextStyles.titleMedium),
                      Text(address.fullAddress, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Payment',
            child: Column(
              children: List.generate(_methods.length, (i) {
                final m = _methods[i];
                final sel = i == _paymentIndex;
                return GestureDetector(
                  onTap: () => setState(() => _paymentIndex = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: sel ? AppColors.primary.withOpacity(0.06) : AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: sel ? AppColors.primary : Colors.transparent, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        Icon(m.icon, color: sel ? AppColors.primary : AppColors.textHint, size: 22),
                        const SizedBox(width: 12),
                        Expanded(child: Text(m.label, style: AppTextStyles.titleMedium.copyWith(color: sel ? AppColors.primary : AppColors.textPrimary))),
                        Text(m.detail, style: AppTextStyles.bodySmall),
                        const SizedBox(width: 8),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 18, height: 18,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: sel ? AppColors.primary : Colors.transparent,
                            border: Border.all(color: sel ? AppColors.primary : AppColors.textHint, width: 1.5),
                          ),
                          child: sel ? const Icon(Icons.check, color: Colors.white, size: 12) : null,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Promo Code',
            child: Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'Enter code',
                    controller: _promoCtrl,
                    prefixIcon: Icons.local_offer_outlined,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _applyPromo(),
                  ),
                ),
                const SizedBox(width: 10),
                AppButton(label: 'Apply', onPressed: _applyPromo, width: 80, size: AppButtonSize.medium),
              ],
            ),
          ),
          if (cart.hasPromo) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(color: AppColors.success.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline, color: AppColors.success, size: 16),
                  const SizedBox(width: 8),
                  Text('Promo "${cart.promoCode}" applied! You saved ${cart.promoDiscount.toCurrency}',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.success)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => ref.read(cartProvider.notifier).removePromo(),
                    child: const Icon(Icons.close, size: 16, color: AppColors.success),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          OrderSummaryCard(
            subtotal: cart.subtotal, deliveryFee: cart.deliveryFee,
            tax: cart.tax, total: cart.total, discount: cart.discount,
          ),
          const SizedBox(height: 16),
          if (cart.totalPoints > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(gradient: AppColors.goldGradient, borderRadius: BorderRadius.circular(14)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('⭐', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text('You\'ll earn ${cart.totalPoints} loyalty points',
                      style: AppTextStyles.labelMedium.copyWith(color: Colors.white)),
                ],
              ),
            ),
          const SizedBox(height: 24),
          AppButton(
            label: 'Place Order • ${cart.total.toCurrency}',
            onPressed: _placeOrder,
            isLoading: _placing,
            gradient: AppColors.primaryGradient,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _PM {
  final IconData     icon;
  final String       label, detail;
  final PaymentMethod method;
  _PM(this.icon, this.label, this.detail, this.method);
}

class _SectionCard extends StatelessWidget {
  final String  title;
  final Widget  child;
  final Widget? action;
  const _SectionCard({required this.title, required this.child, this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface, borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.cardShadows,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(title, style: AppTextStyles.headlineSmall),
            if (action != null) action!,
          ]),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}