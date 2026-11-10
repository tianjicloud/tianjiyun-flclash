import 'package:fl_clash/core/scene.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/views/dashboard/widgets/scene_bar.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('describes each selected scene and daily bypass state', () async {
    final l10n = await AppLocalizations.load(const Locale('zh', 'CN'));

    expect(
      sceneNoteFor(
        l10n,
        scene: SceneKind.daily,
        bulkBypass: true,
        suspended: false,
        unconfirmed: false,
      ),
      '大流量自动绕开家宽 · 大陆流量本地直连',
    );
    expect(
      sceneNoteFor(
        l10n,
        scene: SceneKind.daily,
        bulkBypass: false,
        suspended: false,
        unconfirmed: false,
      ),
      '大陆流量本地直连',
    );
    expect(
      sceneNoteFor(
        l10n,
        scene: SceneKind.ai,
        bulkBypass: false,
        suspended: false,
        unconfirmed: false,
      ),
      'AI 服务走 AI 模式线路 · 大陆流量本地直连',
    );
    expect(
      sceneNoteFor(
        l10n,
        scene: SceneKind.watch,
        bulkBypass: false,
        suspended: false,
        unconfirmed: false,
      ),
      '流媒体走观影线路 · 大陆流量本地直连',
    );
  });

  test(
    'residential suspension takes priority and unconfirmed appends',
    () async {
      final l10n = await AppLocalizations.load(const Locale('zh', 'CN'));

      expect(
        sceneNoteFor(
          l10n,
          scene: SceneKind.ai,
          bulkBypass: false,
          suspended: true,
          unconfirmed: true,
        ),
        '家宽模式下，场景切换已暂停',
      );
      expect(
        sceneNoteFor(
          l10n,
          scene: SceneKind.watch,
          bulkBypass: false,
          suspended: false,
          unconfirmed: true,
        ),
        '流媒体走观影线路 · 大陆流量本地直连 · 部分规则未能切换',
      );
    },
  );
}
