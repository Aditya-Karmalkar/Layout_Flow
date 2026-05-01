import 'package:flutter/material.dart';

/// A modern, adaptive sidebar designed for desktop and tablet layouts.
///
/// Supports collapsible states, headers, footers, and nested navigation items.
class FlowSidebar extends StatefulWidget {
  /// The list of top-level navigation items.
  final List<FlowSidebarItem> items;

  /// The index of the currently selected item.
  final int selectedIndex;

  /// Called when an item is selected.
  final ValueChanged<int>? onItemSelected;

  /// Optional header widget (e.g. logo or user profile).
  final Widget? header;

  /// Optional footer widget (e.g. settings or logout).
  final Widget? footer;

  /// The width of the sidebar when expanded.
  final double width;

  /// The width of the sidebar when collapsed.
  final double collapsedWidth;

  /// Whether the sidebar is currently collapsed.
  final bool isCollapsed;

  /// The background color.
  final Color? backgroundColor;

  const FlowSidebar({
    super.key,
    required this.items,
    this.selectedIndex = 0,
    this.onItemSelected,
    this.header,
    this.footer,
    this.width = 260.0,
    this.collapsedWidth = 72.0,
    this.isCollapsed = false,
    this.backgroundColor,
  });

  @override
  State<FlowSidebar> createState() => _FlowSidebarState();
}

class _FlowSidebarState extends State<FlowSidebar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentWidth = widget.isCollapsed ? widget.collapsedWidth : widget.width;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: currentWidth,
      color: widget.backgroundColor ?? theme.colorScheme.surface,
      child: Column(
        children: [
          if (widget.header != null) widget.header!,
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              itemCount: widget.items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                final item = widget.items[index];
                final isSelected = index == widget.selectedIndex;

                return _SidebarItemWidget(
                  item: item,
                  isSelected: isSelected,
                  isCollapsed: widget.isCollapsed,
                  onTap: () => widget.onItemSelected?.call(index),
                );
              },
            ),
          ),
          if (widget.footer != null) widget.footer!,
        ],
      ),
    );
  }
}

class _SidebarItemWidget extends StatelessWidget {
  final FlowSidebarItem item;
  final bool isSelected;
  final bool isCollapsed;
  final VoidCallback onTap;

  const _SidebarItemWidget({
    required this.item,
    required this.isSelected,
    required this.isCollapsed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final activeColor = isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant;
    final bgColor = isSelected ? colorScheme.primaryContainer.withAlpha(128) : Colors.transparent;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 48,
        padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 0 : 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Icon(
              item.icon,
              color: activeColor,
              size: 24,
            ),
            if (!isCollapsed) ...[
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isSelected ? colorScheme.onPrimaryContainer : colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (item.badge != null) item.badge!,
            ],
          ],
        ),
      ),
    );
  }
}

/// A data class for [FlowSidebar] items.
class FlowSidebarItem {
  final IconData icon;
  final String label;
  final Widget? badge;
  final List<FlowSidebarItem>? children;

  const FlowSidebarItem({
    required this.icon,
    required this.label,
    this.badge,
    this.children,
  });
}
