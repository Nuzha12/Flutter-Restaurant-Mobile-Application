import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../home/presentation/widgets/category_chips.dart';
import '../../providers/menu_provider.dart';
import '../widgets/menu_item_card.dart';

class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuAsync = ref.watch(menuItemsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {
              context.push(RouteNames.search);
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: CategoryChips(),
          ),
          Expanded(
            child: menuAsync.when(
              loading: () => const ShimmerMenuGrid(),
              error: (error, stackTrace) => EmptyStateWidget(
                icon: Icons.error_outline,
                title: 'Failed to load menu',
                subtitle: error.toString(),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return const EmptyStateWidget(
                    icon: Icons.restaurant_menu_rounded,
                    title: 'No items found',
                    subtitle: 'Try selecting a different category',
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    return MenuItemCard(item: items[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}