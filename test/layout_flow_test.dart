import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layout_flow/layout_flow.dart';

void main() {
  group('FlowConfig', () {
    const design = Size(375, 812);

    test('scaleW is 1.0 on exact design size', () {
      final config = FlowConfig(design, design);
      expect(config.scaleW, 1.0);
    });

    test('scaleW doubles on double-width screen', () {
      final config = FlowConfig(const Size(750, 812), design);
      expect(config.scaleW, 2.0);
    });

    test('scaleText is clamped to 0.85 minimum', () {
      // Very narrow screen
      final config = FlowConfig(const Size(200, 812), design);
      expect(config.scaleText, 0.85);
    });

    test('scaleText is clamped to 1.25 maximum', () {
      // Very wide screen
      final config = FlowConfig(const Size(2000, 812), design);
      expect(config.scaleText, 1.25);
    });

    test('w() scales a value by scaleW', () {
      final config = FlowConfig(const Size(750, 812), design);
      expect(config.w(100), 200.0);
    });

    test('text() scales a value with clamped scaleText', () {
      final config = FlowConfig(design, design);
      expect(config.text(16), 16.0);
    });

    group('breakpoints', () {
      test('compact for width < 480', () {
        final config = FlowConfig(const Size(375, 812), design);
        expect(config.breakpoint, FlowBreakpoint.compact);
        expect(config.isCompact, true);
      });

      test('medium for width between 480 and 840', () {
        final config = FlowConfig(const Size(600, 900), design);
        expect(config.breakpoint, FlowBreakpoint.medium);
        expect(config.isMedium, true);
      });

      test('expanded for width >= 840', () {
        final config = FlowConfig(const Size(1024, 768), design);
        expect(config.breakpoint, FlowBreakpoint.expanded);
        expect(config.isExpanded, true);
      });
    });
  });

  group('FlowText widget', () {
    testWidgets('renders text content', (tester) async {
      await tester.pumpWidget(
        const LayoutFlow(
          designSize: Size(375, 812),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: FlowText('Hello layout_flow'),
          ),
        ),
      );
      expect(find.text('Hello layout_flow'), findsOneWidget);
    });

    testWidgets('scales font size from style', (tester) async {
      await tester.pumpWidget(
        const LayoutFlow(
          designSize: Size(375, 812),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: FlowText(
              'Scaled',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      );
      final text = tester.widget<Text>(find.byType(Text));
      expect(text.style?.fontSize, isNotNull);
    });
  });

  group('FlowRow widget', () {
    testWidgets('renders as Column on compact screen', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const LayoutFlow(
          designSize: Size(375, 812),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: FlowRow(
              children: [
                Text('A'),
                Text('B'),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Row), findsNothing);

      addTearDown(tester.view.resetPhysicalSize);
    });

    testWidgets('renders as Row on wide screen', (tester) async {
      tester.view.physicalSize = const Size(1024, 768);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const LayoutFlow(
          designSize: Size(375, 812),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: FlowRow(
              children: [
                Text('A'),
                Text('B'),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Column), findsNothing);

      addTearDown(tester.view.resetPhysicalSize);
    });
  });

  group('FlowSpacing tokens', () {
    testWidgets('returns scaled values', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;

      late double mdValue;

      await tester.pumpWidget(
        LayoutFlow(
          designSize: const Size(375, 812),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Builder(
              builder: (context) {
                mdValue = FlowSpacing.md(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      // On 375 screen with 375 design, scale is 1.0, so md(16) == 16
      expect(mdValue, closeTo(16.0, 0.1));

      addTearDown(tester.view.resetPhysicalSize);
    });
  });
}
