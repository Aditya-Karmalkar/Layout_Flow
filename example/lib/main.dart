import 'package:flutter/material.dart';
import 'package:layout_flow/layout_flow.dart';

void main() {
  runApp(
    const LayoutFlow(
      designSize: Size(375, 812),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'layout_flow Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A73E8)),
        useMaterial3: true,
      ),
      home: const DemoHome(),
    );
  }
}

class DemoHome extends StatelessWidget {
  const DemoHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FlowText(
          'layout_flow',
          style: FlowTextStyle.title(context).copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Login Card demo ──────────────────────────────
            const _SectionLabel('Login Screen Demo'),
            const _LoginCard(),
            SizedBox(height: FlowSpacing.lg(context)),

            // ── Dashboard FlowRow demo ────────────────────────
            const _SectionLabel('Dashboard — FlowRow'),
            Padding(
              padding: FlowSpacing.symmetric(
                context,
                horizontal: 16,
                vertical: 0,
              ),
              child: FlowRow(
                gap: FlowSpacing.md(context),
                children: const [
                  Expanded(child: _StatCard(label: 'Revenue', value: '\$12,400')),
                  Expanded(child: _StatCard(label: 'Users', value: '3,821')),
                  Expanded(child: _StatCard(label: 'Sessions', value: '9,104')),
                ],
              ),
            ),
            SizedBox(height: FlowSpacing.lg(context)),

            // ── Typography scale demo ────────────────────────
            const _SectionLabel('Typography Scale'),
            const _TypeScaleDemo(),
            SizedBox(height: FlowSpacing.xl(context)),
          ],
        ),
      ),
    );
  }
}

// ── Login Card ──────────────────────────────────────────────────────────────

class _LoginCard extends StatelessWidget {
  const _LoginCard();

  @override
  Widget build(BuildContext context) {
    return FlowContainer(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: FlowRadius.lg(context),
        ),
        child: FlowContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FlowText(
                'Welcome back',
                style: FlowTextStyle.headline(context),
              ),
              SizedBox(height: FlowSpacing.xs(context)),
              FlowText(
                'Sign in to your account to continue.',
                style: FlowTextStyle.bodySmall(context).copyWith(
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: FlowSpacing.lg(context)),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: FlowRadius.sm(context),
                  ),
                ),
              ),
              SizedBox(height: FlowSpacing.md(context)),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: FlowRadius.sm(context),
                  ),
                ),
              ),
              SizedBox(height: FlowSpacing.lg(context)),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: FlowSpacing.symmetric(context, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: FlowRadius.md(context),
                  ),
                ),
                child: FlowText(
                  'Sign In',
                  style: FlowTextStyle.body(context).copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Stat Card ───────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: FlowRadius.md(context)),
      child: FlowContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FlowText(
              value,
              style: FlowTextStyle.title(context).copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(height: FlowSpacing.xs(context)),
            FlowText(
              label,
              style: FlowTextStyle.label(context).copyWith(
                color: Colors.grey[600],
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FlowText('Display — 48sp', style: FlowTextStyle.display(context)),
          SizedBox(height: FlowSpacing.sm(context)),
          FlowText('Headline — 32sp', style: FlowTextStyle.headline(context)),
          SizedBox(height: FlowSpacing.sm(context)),
          FlowText('Title — 22sp', style: FlowTextStyle.title(context)),
          SizedBox(height: FlowSpacing.sm(context)),
          FlowText('Body — 16sp', style: FlowTextStyle.body(context)),
          SizedBox(height: FlowSpacing.sm(context)),
          FlowText('Body Small — 14sp', style: FlowTextStyle.bodySmall(context)),
          SizedBox(height: FlowSpacing.sm(context)),
          FlowText('Label — 12sp', style: FlowTextStyle.label(context)),
          SizedBox(height: FlowSpacing.sm(context)),
          FlowText('Micro — 10sp', style: FlowTextStyle.micro(context)),
        ],
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
