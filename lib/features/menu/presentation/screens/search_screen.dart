import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../providers/menu_provider.dart';
import '../widgets/menu_item_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final resultsAsync = ref.watch(searchResultsProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _ctrl,
          autofocus: true,
          style: AppTextStyles.bodyMedium,
          decoration: InputDecoration(
            hintText: 'Search food, cuisine...',
            hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            fillColor: Colors.transparent,
          ),
          onChanged: (v) => ref.read(searchQueryProvider.notifier).state = v,
        ),
        actions: [
          if (query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _ctrl.clear();
                ref.read(searchQueryProvider.notifier).state = '';
              },
            ),
        ],
      ),
      body: query.isEmpty
          ? const EmptyStateWidget(
        icon: Icons.search_rounded,
        title: 'Search for food',
        subtitle: 'Find burgers, pizza, sushi and more',
      )
          : resultsAsync.when(
        loading: () => const ShimmerMenuGrid(),
        error: (e, _) => EmptyStateWidget(
          icon: Icons.error_outline, title: 'Error', subtitle: e.toString(),
        ),
        data: (items) => items.isEmpty
            ? EmptyStateWidget(
          icon: Icons.search_off_rounded,
          title: 'No results',
          subtitle: 'No items found for "$query"',
        )
            : GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: items.length,
          itemBuilder: (_, i) => MenuItemCard(item: items[i]),
        ),
      ),
    );
  }
}