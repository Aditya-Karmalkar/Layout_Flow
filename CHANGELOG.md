# Changelog

## 0.2.0

### Adaptive & Responsive Features
* **FlowGrid**: New responsive grid system with automatic column count calculation.
* **FlowScaffold**: New adaptive shell for switching between Bottom Navigation and Side Rails.
* **FlowNavigationBar**: Adaptive navigation component that switches between BottomBar and NavigationRail.
* **FlowSidebar**: Advanced, collapsible desktop-first navigation with nested item support.
* **FlowVisibility**: New declarative widget to show/hide components based on active breakpoints.
* **FlowRow Refactor**: Switched to `LayoutBuilder` by default. Now adapts based on local parent constraints.
* **New named constructors**: Added `FlowRow.orientation()` and `FlowRow.breakpoint()`.

### Developer Tooling & Ergonomics
* **CLI Migration Tool**: New `dart run layout_flow migrate` command to automatically refactor legacy `MediaQuery` code.
* **DevTools Extension**: Browser-integrated inspector for live breakpoint and scale factor monitoring.
* **FlowDebugOverlay**: New interactive, draggable, and collapsible widget to visualize screen metrics in real-time.
* **FlowContext Extensions**: Added `context.flow`, `context.isCompact`, `context.isExpanded`, etc.
* **Padding Support**: `FlowConfig` now captures and provides safe area padding via `context.flow.padding`.

### Customization & Styling
* **FlowTheme**: Added support for Flutter's `ThemeExtension` to customize the base spacing grid globally.
* **FlowHover**: Utility for desktop/web optimized hover effects and custom cursors.
* **FlowContainer**: Added `scaleContent` parameter for visual child scaling.
* **FlowAdaptiveMode**: Support for switching between global screen and local constraint-based scaling.

## 0.1.0

* Initial release.
* `LayoutFlow` root wrapper with `designSize` configuration.
* Basic `FlowContainer`, `FlowRow`, and `FlowText` implementation.
* Static `FlowSpacing`, `FlowRadius`, and `FlowTextStyle` tokens.
