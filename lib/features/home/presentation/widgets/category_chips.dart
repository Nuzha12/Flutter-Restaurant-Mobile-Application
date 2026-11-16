import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../menu/providers/menu_provider.dart';

class CategoryChips extends ConsumerWidget {
  const CategoryChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedId = ref.watch(selectedCategoryProvider);

    return categoriesAsync.when(
      loading: () => const SizedBox(height: 44),
      error: (_, __) => const SizedBox.shrink(),
      data: (categories) => SizedBox(
        height: 44,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length + 1,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            if (i == 0) {
              final isAll = selectedId == null;
              return FilterChip(
                label: const Text('All'),
                selected: isAll,
                onSelected: (_) => ref.read(selectedCategoryProvider.notifier).state = null,
                backgroundColor: AppColors.surfaceVariant,
                selectedColor: AppColors.primary,
                checkmarkColor: Colors.white,
                labelStyle: AppTextStyles.labelMedium.copyWith(
                    color: isAll ? Colors.white : AppColors.textSecondary),
              );
            }
            final cat = categories[i - 1];
            final isSelected = selectedId == cat.id;
            return FilterChip(
              label: Text('${cat.emoji} ${cat.name}'),
              selected: isSelected,
              onSelected: (_) => ref.read(selectedCategoryProvider.notifier).state = cat.id,
              backgroundColor: AppColors.surfaceVariant,
              selectedColor: AppColors.primary,
              checkmarkColor: Colors.white,
              labelStyle: AppTextStyles.labelMedium.copyWith(
                  color: isSelected ? Colors.white : AppColors.textSecondary),
            );
          },
        ),
      ),
    );
  }
}