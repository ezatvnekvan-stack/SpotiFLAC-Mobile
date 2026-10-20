import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotiflac_android/l10n/app_localizations.dart';
import 'package:spotiflac_android/models/theme_settings.dart';
import 'package:spotiflac_android/theme/nothing_theme.dart';
import 'package:spotiflac_android/widgets/app_bottom_sheet.dart';
import 'package:spotiflac_android/widgets/app_choice_chip.dart';
import 'package:spotiflac_android/widgets/app_search_field.dart';
import 'package:spotiflac_android/widgets/app_sliver_header.dart';
import 'package:spotiflac_android/widgets/settings_group.dart';

double contrast(Color a, Color b) {
  final x = a.computeLuminance();
  final y = b.computeLuminance();
  return ((x > y ? x : y) + 0.05) / ((x > y ? y : x) + 0.05);
}

Widget host(Widget child, Brightness brightness, {double scale = 1}) => MaterialApp(
  theme: NothingTheme.build(brightness),
  locale: const Locale('en'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
    child: child!,
  ),
  home: child,
);

void main() {
  test('Nothing is the fresh-install default without losing old styles', () {
    expect(const ThemeSettings().style, AppThemeStyle.nothing);
    expect(ThemeSettings.fromJson({}).style, AppThemeStyle.nothing);
    for (final style in AppThemeStyle.values) {
      expect(ThemeSettings.fromJson(ThemeSettings(style: style).toJson()).style, style);
    }
  });

  for (final brightness in Brightness.values) {
    test('$brightness has readable text and neutral surfaces', () {
      final theme = NothingTheme.build(brightness);
      final c = theme.colorScheme;
      expect(theme.extension<NothingTheme>(), isNotNull);
      for (final surface in [c.surface, c.surfaceContainerLow, c.surfaceContainerHigh]) {
        expect(contrast(c.onSurface, surface), greaterThanOrEqualTo(7));
        expect(contrast(c.onSurfaceVariant, surface), greaterThanOrEqualTo(4.5));
      }
      expect(contrast(c.onPrimary, c.primary), greaterThanOrEqualTo(4.5));
      expect(theme.textTheme.bodyMedium?.fontFamily, 'Inter');
      expect(theme.textTheme.headlineLarge?.fontFamily, NothingTheme.dotFont);
    });

    testWidgets('$brightness search, selection and sheet keep their actions', (tester) async {
      tester.view.physicalSize = const Size(393, 852);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      var selected = false;
      var changed = '';
      var cleared = false;
      await tester.pumpWidget(host(Scaffold(body: CustomScrollView(slivers: [
        const AppSliverHeader.tabRoot(title: 'Library'),
        SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
          AppSearchField(controller: controller, hintText: 'Search music', clearTooltip: 'Clear',
            onChanged: (value) => changed = value, onClear: () => cleared = true),
          AppChoiceChip(label: const Text('Downloads'), selected: false, onSelected: (value) => selected = value),
          SettingsGroup(children: [SettingsItem(icon: Icons.tune, title: 'Playback', onTap: () {})]),
          Builder(builder: (context) => TextButton(onPressed: () => showModalBottomSheet<void>(
            context: context, builder: (_) => const AppBottomSheet(title: 'Queue', child: Text('Your music'))),
            child: const Text('Open queue'))),
        ]))),
      ])), brightness));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Nothing');
      expect(changed, 'Nothing');
      await tester.tap(find.byTooltip('Clear'));
      expect(cleared, isTrue);
      expect(controller.text, isEmpty);
      await tester.tap(find.text('Downloads'));
      expect(selected, isTrue);
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open queue'));
      await tester.pumpAndSettle();
      expect(find.text('Your music'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('$brightness headings accommodate large accessibility text', (tester) async {
      tester.view.physicalSize = const Size(393, 852);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(host(const Scaffold(body: CustomScrollView(slivers: [
        AppSliverHeader.page(title: 'Network storage and connections'),
        SliverToBoxAdapter(child: SettingsSectionHeader(title: 'Playback settings')),
      ])), brightness, scale: 2));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
