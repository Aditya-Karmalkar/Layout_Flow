// ignore_for_file: avoid_print
import 'dart:io';

void main(List<String> args) async {
  if (args.isEmpty || args[0] != 'migrate') {
    print('Usage: dart run layout_flow migrate [--dry-run] [--path <path>]');
    return;
  }

  bool dryRun = args.contains('--dry-run');
  String path = '.';
  if (args.contains('--path')) {
    int index = args.indexOf('--path');
    if (index + 1 < args.length) {
      path = args[index + 1];
    }
  }

  print('Starting LayoutFlow Migration Tool...');
  print('Scanning: $path');

  final directory = Directory(path);
  if (!directory.existsSync()) {
    print('Error: Path does not exist.');
    return;
  }

  int filesProcessed = 0;
  int filesModified = 0;

  final dartFiles = directory
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'))
      .where((file) => !file.path.contains('.g.dart')) // Skip generated files
      .where((file) => !file.path.contains('.freezed.dart'));

  for (final file in dartFiles) {
    filesProcessed++;
    String content = await file.readAsString();
    String originalContent = content;

    // 1. Replace MediaQuery.of(context).size.width -> context.flow.screen.width
    content = content.replaceAll(
      'MediaQuery.of(context).size.width',
      'context.flow.screen.width',
    );

    // 2. Replace MediaQuery.of(context).size.height -> context.flow.screen.height
    content = content.replaceAll(
      'MediaQuery.of(context).size.height',
      'context.flow.screen.height',
    );

    // 3. Replace MediaQuery.of(context).size -> context.flow.screen
    content = content.replaceAll(
      'MediaQuery.of(context).size',
      'context.flow.screen',
    );

    // 4. Replace MediaQuery.of(context).padding -> context.flow.padding
    content = content.replaceAll(
      'MediaQuery.of(context).padding',
      'context.flow.padding',
    );

    // 5. Replace MediaQuery.sizeOf(context) -> context.flow.screen
    content = content.replaceAll(
      'MediaQuery.sizeOf(context)',
      'context.flow.screen',
    );

    // 6. Common padding patterns
    content = content.replaceAll(
      'MediaQuery.paddingOf(context)',
      'context.flow.padding',
    );

    if (content != originalContent) {
      // Add import if missing
      if (!content.contains('package:layout_flow/layout_flow.dart')) {
        content = "import 'package:layout_flow/layout_flow.dart';\n" + content;
      }

      filesModified++;
      if (dryRun) {
        print('  [DRY RUN] Would modify: ${file.path}');
      } else {
        await file.writeAsString(content);
        print('  ✅ Modified: ${file.path}');
      }
    }
  }

  print('\n🏁 Migration Complete!');
  print('📈 Files Processed: $filesProcessed');
  print('🛠️ Files Modified: $filesModified');
  if (dryRun) print('⚠️ (Dry run - no files were actually changed)');
}
