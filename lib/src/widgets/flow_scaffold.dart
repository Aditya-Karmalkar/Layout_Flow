import 'package:flutter/material.dart';
import '../flow_scope.dart';

/// An adaptive scaffold that simplifies the creation of layouts that switch
/// between mobile-first (bottom navigation) and desktop-first (navigation rail/sidebar)
/// patterns.
///
/// ```dart
/// FlowScaffold(
///   appBar: AppBar(title: Text('My App')),
///   body: Center(child: Text('Content')),
///   bottomNavigationBar: context.isCompact ? myBottomBar : null,
///   // FlowScaffold can eventually automate this logic.
/// )
/// ```
class FlowScaffold extends StatelessWidget {
  /// The primary content of the scaffold.
  final Widget body;

  /// An optional app bar to display at the top.
  final PreferredSizeWidget? appBar;

  /// A navigation widget that adapts based on the screen size.
  ///
  /// Typically a bottom bar on compact screens and a sidebar/rail on expanded screens.
  final Widget? navigation;

  /// Whether the navigation should be placed on the side in expanded mode.
  /// Defaults to true.
  final bool useSideNavigation;

  /// Floating action button to display.
  final Widget? floatingActionButton;

  const FlowScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.navigation,
    this.useSideNavigation = true,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    final isCompact = context.isCompact;

    if (isCompact) {
      return Scaffold(
        appBar: appBar,
        body: body,
        bottomNavigationBar: navigation,
        floatingActionButton: floatingActionButton,
      );
    }

    // Expanded/Medium mode: Use a Row to place navigation on the side
    return Scaffold(
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      body: Row(
        children: [
          if (useSideNavigation && navigation != null) navigation!,
          Expanded(child: body),
        ],
      ),
    );
  }
}
