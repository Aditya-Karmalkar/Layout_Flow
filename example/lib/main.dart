import 'package:flutter/material.dart';
import 'package:layout_flow/layout_flow.dart';

void main() {
  runApp(
    const LayoutFlow(
      designSize: Size(375, 812),
      child: FlowDebugOverlay(
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'layout_flow Showcase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A73E8)),
        useMaterial3: true,
        // New in v0.2.0: Customizing the base spacing grid
        extensions: const [
          FlowTheme(spacingBase: 8.0),
        ],
      ),
      home: const DemoHome(),
    );
  }
}

class DemoHome extends StatefulWidget {
  const DemoHome({super.key});

  @override
  State<DemoHome> createState() => _DemoHomeState();
}

class _DemoHomeState extends State<DemoHome> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return FlowScaffold(
      navigation: FlowNavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          FlowNavigationDestination(
            icon: Icons.dashboard_outlined,
            selectedIcon: Icons.dashboard,
            label: 'Dashboard',
          ),
          FlowNavigationDestination(
            icon: Icons.layers_outlined,
            selectedIcon: Icons.layers,
            label: 'Components',
          ),
          FlowNavigationDestination(
            icon: Icons.settings_outlined,
            selectedIcon: Icons.settings,
            label: 'Settings',
          ),
        ],
      ),
      appBar: AppBar(
        title: FlowText(
          'layout_flow Showcase',
          style: FlowTextStyle.title(context).copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildDashboard(context),
          _buildComponents(context),
          const Center(child: Text('Settings Page')),
        ],
      ),
    );
  }

  Widget _buildDashboard(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionLabel('Responsive Grid — FlowGrid'),
          Padding(
            padding: FlowSpacing.symmetric(context, horizontal: 16),
            child: FlowGrid(
              gap: FlowSpacing.md(context),
              childAspectRatio: context.isCompact
                  ? 3.2
                  : (MediaQuery.of(context).orientation == Orientation.landscape
                      ? 2.0
                      : 2.5),
              columns: const FlowGridColumns(
                compact: 1,
                medium: 2,
                expanded: 4,
              ),
              children: const [
                _StatCard(
                    label: 'Revenue',
                    value: '\$12.4k',
                    icon: Icons.attach_money),
                _StatCard(label: 'Users', value: '3.8k', icon: Icons.people),
                _StatCard(label: 'Sessions', value: '9.1k', icon: Icons.timer),
                _StatCard(
                    label: 'Growth', value: '+14%', icon: Icons.trending_up),
              ],
            ),
          ),
          const _SectionLabel('Adaptive Row — FlowRow'),
          Padding(
            padding: FlowSpacing.symmetric(context, horizontal: 16),
            child: FlowRow(
              gap: FlowSpacing.md(context),
              children: [
                Expanded(
                  child: FlowContainer(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: FlowRadius.md(context),
                    ),
                    child: Column(
                      children: [
                        FlowText('Adaptive Container',
                            style: FlowTextStyle.title(context)),
                        SizedBox(height: FlowSpacing.sm(context)),
                        const FlowText('Resize window to see me stack!'),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: FlowContainer(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: FlowRadius.md(context),
                    ),
                    child: Column(
                      children: [
                        FlowText('Scaling Magic',
                            style: FlowTextStyle.title(context)),
                        SizedBox(height: FlowSpacing.sm(context)),
                        const FlowText('Everything scales proportionally.'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: FlowSpacing.xxl(context)),
        ],
      ),
    );
  }

  Widget _buildComponents(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionLabel('Visibility — FlowVisibility'),
          FlowContainer(
            child: Card(
              child: FlowContainer(
                child: Row(
                  children: [
                    const Icon(Icons.info_outline),
                    SizedBox(width: FlowSpacing.md(context)),
                    Expanded(
                      child: FlowText(
                        'Try resizing your browser or screen.',
                        style: FlowTextStyle.body(context),
                      ),
                    ),
                    FlowVisibility.expandedOnly(
                      child: Chip(
                        label: const Text('Desktop Exclusive Badge'),
                        backgroundColor: Colors.blue.shade100,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const _SectionLabel('Typography Scale'),
          const _TypeScaleDemo(),
          SizedBox(height: FlowSpacing.xxl(context)),
        ],
      ),
    );
  }
}

// ── Stat Card ───────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // New in v0.2.0: using context.isCompact extension
    final bool isCompact = context.isCompact;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: FlowRadius.md(context)),
      child: FlowContainer(
        padding: FlowSpacing.symmetric(context, horizontal: 16, vertical: 8),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!isCompact) ...[
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              SizedBox(width: FlowSpacing.md(context)),
            ],
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FlowText(
                      value,
                      style: FlowTextStyle.title(context).copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                    ),
                    FlowText(
                      label,
                      style: FlowTextStyle.label(context).copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Type Scale Demo ─────────────────────────────────────────────────────────

class _TypeScaleDemo extends StatelessWidget {
  const _TypeScaleDemo();

  @override
  Widget build(BuildContext context) {
    return FlowContainer(
      padding: FlowSpacing.all(context, 16),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            FlowText('Display — Hero text',
                style: FlowTextStyle.display(context)),
            SizedBox(height: FlowSpacing.md(context)),
            FlowText('Headline — Page headers',
                style: FlowTextStyle.headline(context)),
            SizedBox(height: FlowSpacing.md(context)),
            FlowText('Title — Section headers',
                style: FlowTextStyle.title(context)),
            SizedBox(height: FlowSpacing.md(context)),
            FlowText('Body — Standard copy',
                style: FlowTextStyle.body(context)),
            SizedBox(height: FlowSpacing.sm(context)),
            FlowText('Label — Captions', style: FlowTextStyle.label(context)),
            SizedBox(height: FlowSpacing.xs(context)),
            FlowText('Micro — Small badges',
                style: FlowTextStyle.micro(context)),
          ],
        ),
      ),
    );
  }
}

// ── Section Label ───────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: FlowSpacing.only(context, left: 16, top: 16, bottom: 8),
      child: FlowText(
        text.toUpperCase(),
        style: FlowTextStyle.label(context).copyWith(
          color: Colors.grey[500],
          letterSpacing: 1.2,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
