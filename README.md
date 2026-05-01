# layout_flow

[![pub.dev](https://img.shields.io/pub/v/layout_flow.svg)](https://pub.dev/packages/layout_flow)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-%E2%89%A53.10.0-blue)](https://flutter.dev)

**Write UI once. Let it flow across every screen.**

`layout_flow` is a constraint-driven, adaptive layout system for Flutter. It eliminates manual screen sizing, font scaling, and breakpoint boilerplate — so you write UI once and it just works on phones, tablets, and the web.

![layout_flow demo — resize the window and watch the layout adapt automatically](https://raw.githubusercontent.com/Aditya-Karmalkar/Layout_Flow/main/assets/layout_flow.gif)

> Resize the window (or rotate your phone) — `FlowRow` switches between Row and Column automatically, and all text/spacing scales with no code changes.

---

## The Problem With Existing Approaches

Building responsive Flutter UIs today forces you to choose between three bad options:

---

### ❌ Option 1 — Raw MediaQuery (Verbose & Fragile)

Every widget that needs to be responsive must individually query the screen and compute scaled values. Logic is scattered everywhere, magic numbers creep in, and the code becomes brittle.

```dart
// You write this in EVERY widget that needs responsiveness
class MyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = size.width / 375; // magic number: your design width

    return Container(
      width: 160 * scale,
      height: 80 * scale,
      padding: EdgeInsets.all(16 * scale),
      child: Text(
        'Revenue',
        style: TextStyle(
          fontSize: (16 * scale).clamp(12, 22), // manual clamping
        ),
      ),
    );
  }
}
```

**Problems:** Magic numbers everywhere, repeated logic in every widget, no shared system for spacing or typography, easy to forget clamping on text.

---

### ❌ Option 2 — flutter_screenutil (Requires Init + Leaks Numbers)

`flutter_screenutil` is popular but has real friction: you must call `ScreenUtil.init()` before use, every value needs a `.w`, `.h`, or `.sp` extension call, and raw numbers still litter your codebase.

```dart
// Setup — must call init before any widget builds
ScreenUtilInit(
  designSize: const Size(375, 812),
  builder: (context, child) => MyApp(),
)

// Usage — extension calls on every single value
Container(
  width: 160.w,
  height: 80.h,
  padding: EdgeInsets.symmetric(
    horizontal: 16.w,
    vertical: 12.h,
  ),
  child: Text(
    'Revenue',
    style: TextStyle(fontSize: 16.sp),
  ),
)
```

**Problems:** Raw numbers still pollute the codebase (just with suffixes), no token system for consistent spacing/typography, no smart layout switching between Row/Column, relies on global state via extension methods.

---

### ❌ Option 3 — Separate Layouts Per Breakpoint (Code Duplication)

The "correct" way without a library is writing entirely different widgets for each screen size. Safe, but extremely repetitive.

```dart
Widget build(BuildContext context) {
  final width = MediaQuery.of(context).size.width;

  if (width < 480) {
    return _CompactLayout(); // maintain separately
  } else if (width < 840) {
    return _MediumLayout();  // maintain separately
  } else {
    return _ExpandedLayout(); // maintain separately
  }
}
// Now repeat this for every screen in your app...
```

**Problems:** 3× the code to maintain, inconsistent designs across breakpoints, huge cognitive overhead.

---

## ✅ The layout_flow Way

One setup. Shared tokens. Widgets that adapt automatically.

![layout_flow adaptive layout in action](https://raw.githubusercontent.com/Aditya-Karmalkar/Layout_Flow/main/assets/layout_flow.gif)

```dart
// main.dart — one-time setup
void main() {
  runApp(
    const LayoutFlow(
      designSize: Size(375, 812), // match your Figma frame
      child: MyApp(),
    ),
  );
}

// MyCard — no MediaQuery, no magic numbers, no boilerplate
class MyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlowContainer(
      child: FlowRow(
        gap: FlowSpacing.md(context),
        children: [
          Expanded(
            child: FlowText('Revenue',
              style: FlowTextStyle.title(context)),
          ),
          Expanded(
            child: FlowText('\$12,400',
              style: FlowTextStyle.headline(context)),
          ),
        ],
      ),
    );
  }
}
```

- **No raw numbers.** Spacing, text, and radii come from tokens.
- **No repeated setup.** The `LayoutFlow` root configures everything once.
- **No breakpoint conditionals.** `FlowRow` switches between Row and Column automatically.
- **No `.w` / `.h` on every value.** Tokens scale themselves.

---

## How It Works Internally

Understanding the architecture helps you use `layout_flow` confidently and override it when needed.

```
LayoutFlow  (root wrapper — you add this once)
   ↓
   uses LayoutBuilder to read the current constraints
   ↓
FlowConfig  (the scaling engine)
   │  scaleW   = screen.width  / design.width   → width scale factor
   │  scaleH   = screen.height / design.height  → height scale factor
   │  scaleText = scaleW.clamp(0.85, 1.25)      → clamped, safe text scale
   │  sp()      = min(scaleW, scaleH).clamp(...)→ symmetric scale (icons, radii)
   │  breakpoint = compact / medium / expanded  → inferred from screen width
   ↓
FlowScope  (InheritedWidget — propagates config down the tree)
   ↓
Tokens + Widgets  (consume FlowScope.of(context) to read FlowConfig)
   │  FlowText       → scales fontSize via config.text()
   │  FlowContainer  → applies token-based padding via config.w()
   │  FlowRow        → switches Row ↔ Column based on config.screen.width
   │  FlowSpacing    → returns scaled double values for spacing
   │  FlowTextStyle  → returns scaled TextStyle objects
   └  FlowRadius     → returns scaled BorderRadius objects
```

### Why `LayoutBuilder` and not `MediaQuery`?

`MediaQuery` returns the full device screen size. But if `LayoutFlow` is placed inside a panel, a dialog, or a split view, `MediaQuery` would give the *device* width — not the *available* width. `LayoutBuilder` gives the actual constraints from the parent, which is always correct.

> **Fallback:** If parent constraints are unconstrained (e.g., inside a `ScrollView` without a defined axis), `LayoutFlow` automatically falls back to `MediaQuery.sizeOf(context)`.

### Why `InheritedWidget` and not a Provider/Riverpod?

`FlowConfig` is read-only data derived purely from screen size — it has no mutable state. `InheritedWidget` is the most lightweight, zero-dependency way to propagate read-only context in Flutter. No external package needed, and it rebuilds dependents only when screen dimensions actually change.

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  layout_flow: ^0.1.0
```

Then run:

```sh
flutter pub get
```

---

## Quick Start

**Step 1:** Wrap your root app with `LayoutFlow`:

```dart
import 'package:layout_flow/layout_flow.dart';

void main() {
  runApp(
    const LayoutFlow(
      designSize: Size(375, 812), // your Figma/design reference frame
      child: MyApp(),
    ),
  );
}
```

**Step 2:** Use Flow widgets anywhere in your tree. No extra setup.

```dart
FlowContainer(
  child: Column(
    children: [
      FlowText('Welcome back', style: FlowTextStyle.headline(context)),
      SizedBox(height: FlowSpacing.sm(context)),
      FlowText('Sign in to continue', style: FlowTextStyle.bodySmall(context)),
    ],
  ),
)
```

That's it.

---

## Widgets

### `LayoutFlow` — Root Wrapper

The single entry point for the entire system. Wrap your `MaterialApp` or `CupertinoApp` with it.

```dart
LayoutFlow(
  designSize: const Size(375, 812), // optional, defaults to Size(375, 812)
  child: MyApp(),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `designSize` | `Size` | `Size(375, 812)` | The screen size of your design reference (Figma frame, etc.) |
| `child` | `Widget` | required | Your app widget |

**Common design sizes:**

```dart
LayoutFlow(designSize: const Size(375, 812))  // iPhone SE / compact
LayoutFlow(designSize: const Size(390, 844))  // iPhone 14
LayoutFlow(designSize: const Size(393, 852))  // iPhone 14 Pro
LayoutFlow(designSize: const Size(412, 915))  // Pixel 7
```

---

### `FlowText` — Auto-Scaling Text

Renders text with an automatically scaled font size. No need to ever specify `fontSize` manually.

```dart
// Minimal — uses 16sp base, scales automatically
FlowText('Hello World')

// With a token style
FlowText('Page Title', style: FlowTextStyle.headline(context))

// With custom base size — still scales automatically
FlowText('Custom', style: const TextStyle(fontSize: 20, color: Colors.blue))

// With overflow control
FlowText(
  'Long text that might overflow...',
  maxLines: 2,
  overflow: TextOverflow.fade,
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `data` | `String` | required | The text to display |
| `style` | `TextStyle?` | `null` | Base style. If `fontSize` is set, it becomes the base to scale from |
| `textAlign` | `TextAlign?` | `null` | Text alignment |
| `overflow` | `TextOverflow?` | `ellipsis` | How to handle overflow |
| `maxLines` | `int?` | `null` | Maximum number of lines |

**How it scales:** If `style.fontSize` is provided, that value is used as the base. Otherwise, `16.0` is the default base. The base is multiplied by `FlowConfig.scaleText`, which is clamped between `0.85×` and `1.25×` to prevent extreme sizes.

---

### `FlowContainer` — Adaptive Container

A container that applies token-based padding without requiring explicit `width` or `height`. Sizing is driven by content and parent constraints.

```dart
// Default — 16dp padding on all sides (scaled)
FlowContainer(child: MyWidget())

// Custom padding using tokens
FlowContainer(
  padding: FlowSpacing.symmetric(context, horizontal: 24, vertical: 16),
  child: MyWidget(),
)

// With decoration and margin
FlowContainer(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: FlowRadius.lg(context),
    boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black12)],
  ),
  margin: FlowSpacing.all(context, 8),
  child: MyWidget(),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `child` | `Widget` | required | The child widget |
| `padding` | `EdgeInsetsGeometry?` | `FlowSpacing.md` all sides | Inner padding |
| `margin` | `EdgeInsetsGeometry?` | `null` | Outer margin |
| `decoration` | `BoxDecoration?` | `null` | Background, border, shadow |
| `width` | `double?` | `null` | If set, scaled via `config.w()` |
| `height` | `double?` | `null` | If set, scaled via `config.h()` |
| `alignment` | `AlignmentGeometry?` | `null` | Child alignment |

---

### `FlowRow` — Smart Row ↔ Column Switcher

Renders children side-by-side on wider screens and stacks them vertically on compact screens. No conditional logic in your UI code.

```dart
FlowRow(
  gap: FlowSpacing.md(context),
  children: [
    Expanded(child: StatCard(label: 'Revenue', value: '\$12k')),
    Expanded(child: StatCard(label: 'Users', value: '3.8k')),
    Expanded(child: StatCard(label: 'Sessions', value: '9.1k')),
  ],
)
```

On a **phone** (width < 480dp) → stacks as `Column`.  
On a **tablet or web** (width ≥ 480dp) → renders as `Row`.

```dart
// Customise the breakpoint and alignment
FlowRow(
  breakpoint: 600,                                    // custom switch point
  gap: FlowSpacing.sm(context),
  rowMainAxisAlignment: MainAxisAlignment.spaceEvenly,
  columnCrossAxisAlignment: CrossAxisAlignment.start,
  children: [...],
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `children` | `List<Widget>` | required | Child widgets |
| `breakpoint` | `double` | `480` | Width threshold for Row↔Column switch |
| `gap` | `double?` | `null` | Gap inserted between children |
| `rowMainAxisAlignment` | `MainAxisAlignment` | `start` | Main axis alignment in Row mode |
| `rowCrossAxisAlignment` | `CrossAxisAlignment` | `center` | Cross axis alignment in Row mode |
| `columnMainAxisAlignment` | `MainAxisAlignment` | `start` | Main axis alignment in Column mode |
| `columnCrossAxisAlignment` | `CrossAxisAlignment` | `stretch` | Cross axis alignment in Column mode |

---

## Tokens

### `FlowSpacing` — Spacing Scale

All values are based on an 8dp grid and scale proportionally with the screen width.

```dart
FlowSpacing.xs(context)    // → 4dp scaled
FlowSpacing.sm(context)    // → 8dp scaled
FlowSpacing.md(context)    // → 16dp scaled  (standard card padding)
FlowSpacing.lg(context)    // → 24dp scaled  (section gap)
FlowSpacing.xl(context)    // → 32dp scaled  (major separator)
FlowSpacing.xxl(context)   // → 48dp scaled  (screen-level rhythm)
```

**EdgeInsets helpers** — build padding/margin directly:

```dart
// Uniform padding
FlowSpacing.all(context, 16)

// Symmetric padding
FlowSpacing.symmetric(context, horizontal: 24, vertical: 12)

// Individual sides (horizontal uses scaleW, vertical uses scaleH)
FlowSpacing.only(context, left: 16, top: 8, right: 16, bottom: 8)
```

---

### `FlowTextStyle` — Typography Scale

Returns a pre-configured, scaled `TextStyle`. Pairs perfectly with `FlowText`.

```dart
FlowTextStyle.display(context)    // 48sp  — hero / splash text
FlowTextStyle.headline(context)   // 32sp  — page/section headings
FlowTextStyle.title(context)      // 22sp  — card titles, dialog headers
FlowTextStyle.body(context)       // 16sp  — standard body copy
FlowTextStyle.bodySmall(context)  // 14sp  — secondary body text
FlowTextStyle.label(context)      // 12sp  — labels, captions
FlowTextStyle.micro(context)      // 10sp  — badges, fine print
```

You can override font weight or chain `.copyWith()`:

```dart
FlowTextStyle.headline(context, weight: FontWeight.w400)

FlowTextStyle.body(context).copyWith(color: Colors.grey, letterSpacing: 0.5)
```

---

### `FlowRadius` — Border Radius Scale

Returns a scaled `BorderRadius`. All values scale using `sp()` — the minimum of width and height scale — so radii stay proportional on both portrait and landscape.

```dart
FlowRadius.sm(context)    // 4dp  — inputs, chips
FlowRadius.md(context)    // 8dp  — standard cards
FlowRadius.lg(context)    // 12dp — prominent cards, bottom sheets
FlowRadius.xl(context)    // 16dp — modals, dialogs
FlowRadius.xxl(context)   // 24dp — large surfaces
FlowRadius.full(context)  // 999dp — pill buttons, avatars (fully circular)
```

```dart
// Usage with a Card
Card(
  shape: RoundedRectangleBorder(borderRadius: FlowRadius.md(context)),
  child: ...,
)

// Usage with a TextField
TextField(
  decoration: InputDecoration(
    border: OutlineInputBorder(borderRadius: FlowRadius.sm(context)),
  ),
)
```

---

## Breakpoints

`layout_flow` defines three breakpoints aligned with **Material Design 3**:

| Name | Width | Typical device |
|---|---|---|
| `compact` | < 480dp | Phone in portrait |
| `medium` | 480–839dp | Phone landscape, small tablet |
| `expanded` | ≥ 840dp | Tablet, desktop, web |

Access the current breakpoint anywhere in your widget tree:

```dart
final flow = FlowScope.of(context);

// Boolean helpers
if (flow.isCompact)  { /* phone portrait layout */ }
if (flow.isMedium)   { /* tablet-ish layout */ }
if (flow.isExpanded) { /* desktop / wide layout */ }

// Or use the enum directly
switch (flow.breakpoint) {
  case FlowBreakpoint.compact:  return PhoneLayout();
  case FlowBreakpoint.medium:   return TabletLayout();
  case FlowBreakpoint.expanded: return DesktopLayout();
}
```

---

## Manual Scaling

For cases where you need to scale a one-off value that doesn't fit a token, access `FlowConfig` directly via `FlowScope`:

```dart
final flow = FlowScope.of(context);

// Scale a width-based value (horizontal dimensions)
double iconSize = flow.w(24);

// Scale a height-based value (vertical dimensions)
double buttonHeight = flow.h(48);

// Scale a font size (clamped to 0.85–1.25×)
double customFontSize = flow.text(18);

// Scale symmetrically — useful for icons, avatar sizes, border radii
// Uses the smaller of width/height scale, clamped to 0.85–1.3×
double avatarRadius = flow.sp(20);
```

`maybeOf` is available if `LayoutFlow` might not be present (returns `null` instead of asserting):

```dart
final flow = FlowScope.maybeOf(context);
if (flow != null) { /* use flow */ }
```

---

## package:layout_flow vs Others — Side-by-Side

### Building a responsive card with a title, subtitle, and padded layout

#### With `MediaQuery` (raw)
```dart
class MyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final scale = w / 375;
    return Container(
      padding: EdgeInsets.all(16 * scale),
      child: Column(children: [
        Text('Title',    style: TextStyle(fontSize: (22 * scale).clamp(16, 28))),
        SizedBox(height: 8 * scale),
        Text('Subtitle', style: TextStyle(fontSize: (14 * scale).clamp(11, 18))),
      ]),
    );
  }
}
```
Lines of code: **11**. Magic numbers: **6**. Repeated in every widget.

---

#### With `flutter_screenutil`
```dart
class MyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(children: [
        Text('Title',    style: TextStyle(fontSize: 22.sp)),
        SizedBox(height: 8.h),
        Text('Subtitle', style: TextStyle(fontSize: 14.sp)),
      ]),
    );
  }
}
```
Lines of code: **10**. Raw numbers: **5** (just with suffixes). No token system for consistency.

---

#### With `layout_flow`
```dart
class MyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlowContainer(
      child: Column(children: [
        FlowText('Title',    style: FlowTextStyle.title(context)),
        SizedBox(height: FlowSpacing.sm(context)),
        FlowText('Subtitle', style: FlowTextStyle.bodySmall(context)),
      ]),
    );
  }
}
```
Lines of code: **9**. Raw numbers: **0**. Consistent tokens. Scales everywhere.

---

### Building a 2-column dashboard that stacks on mobile

#### With `flutter_screenutil` / MediaQuery
```dart
Widget build(BuildContext context) {
  final isWide = MediaQuery.of(context).size.width >= 480;
  final gap = 16.0 * (MediaQuery.of(context).size.width / 375);

  if (isWide) {
    return Row(children: [
      Expanded(child: StatCard()),
      SizedBox(width: gap),
      Expanded(child: StatCard()),
    ]);
  }
  return Column(children: [
    StatCard(),
    SizedBox(height: gap),
    StatCard(),
  ]);
}
```
Lines of code: **16**. Conditional branching you must repeat for every section.

---

#### With `layout_flow`
```dart
Widget build(BuildContext context) {
  return FlowRow(
    gap: FlowSpacing.md(context),
    children: [
      Expanded(child: StatCard()),
      Expanded(child: StatCard()),
    ],
  );
}
```
Lines of code: **7**. No conditionals. No repeated logic. Switches automatically.

---

## Architecture Deep Dive

### `FlowConfig` — The Scaling Engine

`FlowConfig` is a plain Dart class (no `ChangeNotifier`, no streams) created fresh whenever screen dimensions change. It computes all scale factors once during construction.

```
scaleW    = screen.width  / design.width
scaleH    = screen.height / design.height
scaleText = scaleW.clamp(0.85, 1.25)       ← prevents too-small or too-large text
sp scale  = min(scaleW, scaleH).clamp(0.85, 1.3) ← for symmetric elements
breakpoint = compact | medium | expanded   ← from screen.width thresholds
```

### `FlowScope` — The InheritedWidget

`FlowScope` wraps the entire app subtree and provides `FlowConfig` to any descendant widget via `FlowScope.of(context)`. It only triggers rebuilds when `screen` or `design` dimensions actually change — not on every frame.

### `LayoutFlow` — The Root Wrapper

`LayoutFlow` uses `LayoutBuilder` to receive the tightest constraints from its parent. It constructs a `FlowConfig` from those constraints and injects it into the tree via `FlowScope`. If constraints are unconstrained (e.g., inside a `ListView`), it falls back to `MediaQuery.sizeOf(context)` automatically.

---

## Example App

The `/example` folder contains a complete demo app showing:

- **Login Screen** — `FlowContainer`, `FlowText`, `FlowTextStyle`, `FlowSpacing`, `FlowRadius` all working together without a single raw number
- **Dashboard** — `FlowRow` with 3 stat cards that stack on mobile and spread on wide screens
- **Typography Scale** — All 7 `FlowTextStyle` levels rendered side-by-side so you can see the scaling live

Run it:

```sh
cd example
flutter run
```

Try resizing the window (on web or desktop) to see `FlowRow` switch between Row and Column in real time.

---

## Testing

`layout_flow` ships with a full test suite covering:

- `FlowConfig` scale factors and breakpoint resolution
- `FlowText` rendering and font scaling
- `FlowRow` Row ↔ Column switching at correct breakpoints
- `FlowSpacing` token values at 1:1 scale

```sh
flutter test
```

All 14 tests pass. ✅

---

## Compatibility

| Requirement | Version |
|---|---|
| Dart SDK | ≥ 3.0.0 < 4.0.0 |
| Flutter | ≥ 3.10.0 |
| Dependencies | **none** (only Flutter SDK) |

`layout_flow` has **zero external dependencies**. It uses only core Flutter widgets (`LayoutBuilder`, `InheritedWidget`, `Text`, `Container`, `Row`, `Column`).

---

## Roadmap

- [ ] `FlowGrid` — responsive grid with auto column count
- [ ] `FlowScaffold` — full-page adaptive layout with sidebar support
- [ ] DevTools extension — live breakpoint and scale factor inspector
- [ ] CLI migration tool — refactor `MediaQuery` and `.w`/`.h` usages automatically

---

## Contributing

Contributions, issues, and feature requests are welcome!  
See the [GitHub repository](https://github.com/Aditya-Karmalkar/Layout_Flow) to get started.

---

## License

MIT — see [LICENSE](LICENSE).
