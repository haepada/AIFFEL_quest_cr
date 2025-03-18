import 'package:flutter/material.dart';

class CategorySelector extends StatefulWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategorySelector({
    Key? key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: widget.categories.map((category) {
          final isSelected = category == widget.selectedCategory;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => widget.onCategorySelected(category),
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.primary.withOpacity(0.15)
                          : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: isSelected 
                          ? [
                              BoxShadow(
                                color: theme.colorScheme.primary.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              )
                            ]
                          : [
                              BoxShadow(
                                color: theme.colorScheme.shadow.withOpacity(0.08),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              )
                            ],
                    ),
                    child: Row(
                      children: [
                        isSelected
                            ? Icon(
                                Icons.check_circle,
                                size: 20,
                                color: theme.colorScheme.primary,
                              )
                            : Icon(
                                Icons.circle_outlined,
                                size: 20,
                                color: theme.colorScheme.onSurface.withOpacity(0.5),
                              ),
                        const SizedBox(width: 8),
                        Text(
                          category,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface.withOpacity(0.8),
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
} 