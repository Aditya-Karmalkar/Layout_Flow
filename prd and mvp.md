📄 PRODUCT REQUIREMENTS DOCUMENT (PRD)
🧾 Product Name

layout_flow

🏷️ Tagline

Write UI once. Let it flow across every screen.

🎯 Problem Statement

Flutter developers currently:

read screen size via MediaQuery
scale UI with packages like flutter_screenutil
create separate layouts or breakpoints

👉 Result:

repetitive code
fragile layouts
high cognitive load
💡 Solution

layout_flow provides a constraint-driven, adaptive layout system where:

UI components automatically flow and adjust across devices—without requiring explicit width/height or manual scaling.

🎯 Goals
Primary
Zero or minimal manual sizing (width, height)
Sensible defaults (works out-of-the-box)
Consistent behavior across phone, tablet, web
Flutter-like, low-friction API
Secondary
Token-based spacing & typography
Smart layout switching (row ↔ column)
Easy opt-out/override when needed
❌ Non-Goals
Not a Figma auto-layout clone
Not only a scaler (.w, .h)
Not requiring multiple layouts per breakpoint
👤 Target Users
Beginners who struggle with responsiveness
Builders/hackathons shipping fast
Full-stack devs who want “just works” UI
Teams wanting consistent spacing/typography
🧩 Core Concepts
Flow Context – global config (screen, scale, breakpoints)
Flow Tokens – spacing, text, radius (no raw numbers)
Flow Widgets – adaptive primitives (Container/Text/Row)
Constraint-first Layout – prefer Expanded, Flexible, fractions
🔥 Core Features
1) Root Wrapper
LayoutFlow(
  designSize: const Size(375, 812),
  child: MyApp(),
)
Initializes config
Provides context to all children
2) FlowText (no font size required)
FlowText("Welcome")
Auto font scaling
Safe min/max clamps
Handles overflow
3) FlowContainer (no width/height)
FlowContainer(
  child: ...
)
Token-based padding
Content-driven sizing
4) FlowRow (smart switching)
FlowRow(
  children: [...]
)
Row → Column on small screens
Adjustable breakpoint
5) Tokens (design system)
FlowSpacing.md
FlowTextStyle.body
Scales automatically with screen
⚙️ Functional Requirements
Area	Requirement
Scaling	Based on screen vs design size
Text	Auto-scale with clamp
Layout	Switch based on width
Spacing	Token-driven
Access	Global via context
⚡ Non-Functional Requirements
Lightweight (<100KB target)
No layout jank
Flutter stable compatible
Composable with existing widgets
🧱 Architecture
LayoutFlow (root)
   ↓
FlowScope (InheritedWidget)
   ↓
FlowConfig (engine)
   ↓
Tokens + Widgets
📊 Success Metrics
Pub.dev score & likes
Weekly downloads
GitHub stars/issues
“Works out-of-the-box” feedback
🚀 MVP PLAN (v0.1.0)

Keep it tight. Ship fast.

✅ Included
LayoutFlow (root)
FlowConfig (scaling engine)
FlowScope (context)
FlowText
FlowContainer
FlowRow
Basic tokens (spacing, text)
❌ Not in MVP
Grid system
CLI refactor tool
Advanced theming
DevTools plugin
🧠 CORE IMPLEMENTATION (MVP)
1) FlowConfig
class FlowConfig {
  final Size screen;
  final Size design;

  late final double scaleW;
  late final double scaleText;

  FlowConfig(this.screen, this.design) {
    scaleW = screen.width / design.width;
    scaleText = scaleW.clamp(0.85, 1.2);
  }

  double w(double v) => v * scaleW;
  double text(double v) => v * scaleText;
}
2) FlowScope
class FlowScope extends InheritedWidget {
  final FlowConfig config;

  const FlowScope({
    required this.config,
    required super.child,
  });

  static FlowConfig of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<FlowScope>()!
        .config;
  }

  @override
  bool updateShouldNotify(_) => true;
}
3) LayoutFlow (root)
class LayoutFlow extends StatelessWidget {
  final Widget child;
  final Size designSize;

  const LayoutFlow({
    required this.child,
    required this.designSize,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final config = FlowConfig(
          constraints.biggest,
          designSize,
        );

        return FlowScope(
          config: config,
          child: child,
        );
      },
    );
  }
}
4) FlowText
class FlowText extends StatelessWidget {
  final String data;
  final TextStyle? style;

  const FlowText(this.data, {this.style});

  @override
  Widget build(BuildContext context) {
    final flow = FlowScope.of(context);
    final base = style?.fontSize ?? 16;

    return Text(
      data,
      overflow: TextOverflow.ellipsis,
      style: style?.copyWith(
            fontSize: flow.text(base),
          ) ??
          TextStyle(
            fontSize: flow.text(base),
          ),
    );
  }
}
5) FlowContainer
class FlowContainer extends StatelessWidget {
  final Widget child;

  const FlowContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    final flow = FlowScope.of(context);

    return Padding(
      padding: EdgeInsets.all(flow.w(16)),
      child: child,
    );
  }
}
6) FlowRow
class FlowRow extends StatelessWidget {
  final List<Widget> children;
  final double breakpoint;

  const FlowRow({
    required this.children,
    this.breakpoint = 420,
  });

  @override
  Widget build(BuildContext context) {
    final flow = FlowScope.of(context);

    if (flow.screen.width < breakpoint) {
      return Column(children: children);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    );
  }
}
7) Tokens
class FlowSpacing {
  static double sm(BuildContext c) => FlowScope.of(c).w(8);
  static double md(BuildContext c) => FlowScope.of(c).w(16);
  static double lg(BuildContext c) => FlowScope.of(c).w(24);
}
📱 MVP DEMO APP (THIS DRIVES ADOPTION)
1) Login Screen
FlowText title
FlowContainer wrapper
No widths anywhere
2) Dashboard
FlowRow with 2 cards
Auto stack on mobile
🎬 Must-have demo
Resize screen (web/emulator)
Show layout switching automatically

👉 This is what makes your package feel “magical”

🗺️ Timeline (4 weeks)
Week 1
Core engine (FlowConfig + Scope)
Week 2
FlowText + FlowContainer
Week 3
FlowRow + tokens
Week 4
Example app + README + publish
⚠️ Risks & Mitigation
Risk	Fix
Too magical	Allow overrides
Edge layout bugs	Use constraints, not fixed sizes
Low adoption	Strong demo
🏆 Final Positioning

layout_flow is not a scaling tool.
It’s a layout behavior system.