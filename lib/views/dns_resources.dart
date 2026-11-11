import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/views/resources.dart';
import 'package:fl_clash/views/dns_queries.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DnsResourcesView extends ConsumerWidget {
  const DnsResourcesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ViewScope.isMobileOf(context)) return const DnsQueriesView();
    final dns = ref.watch(
      patchClashConfigProvider.select((config) => config.dns),
    );
    final mode = switch (dns.enhancedMode) {
      DnsMode.fakeIp => 'fake-ip',
      DnsMode.redirHost => 'redir-host',
      DnsMode.normal => 'normal',
      DnsMode.hosts => 'hosts',
    };
    final upstream = dns.nameserver.isEmpty
        ? context.appLocalizations.unknown
        : _upstreamLabel(dns.nameserver.first);
    final updateHours = ref.watch(
      patchClashConfigProvider.select(
        (config) => config.geoAutoUpdate ? config.geoUpdateInterval : null,
      ),
    );
    return Scaffold(
      title: context.appLocalizations.dnsResourcesDesktop,
      actions: [
        _HeaderLabel(context.appLocalizations.dnsMode),
        _HeaderChip(mode, selected: true),
        _HeaderLabel(context.appLocalizations.dnsUpstream),
        _HeaderChip(upstream),
      ],
      body: Padding(
        padding: EdgeInsets.fromLTRB(24, context.contentTopPadding, 24, 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Expanded(
              child: _Panel(
                child: DnsQueriesView(embedded: true, desktopPanel: true),
              ),
            ),
            const SizedBox(width: 14),
            SizedBox(
              width: 380,
              child: _Panel(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 12, 12, 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context
                                      .appLocalizations
                                      .routingResourcesDesktop,
                                  style: AppTextStyle.subheadline.of(
                                    context,
                                    emphasized: true,
                                  ),
                                ),
                                Text(
                                  context
                                      .appLocalizations
                                      .routingResourcesSubtitle,
                                  style: AppTextStyle.caption1
                                      .of(context)
                                      .copyWith(
                                        color: context
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () => globalState.safeRun(() async {
                              final failures = await ref
                                  .read(resourcesActionProvider.notifier)
                                  .updateAll();
                              dialogs.showFailures(failures);
                            }),
                            style: const ButtonStyle(
                              minimumSize: Size(84, 30),
                              fixedSize: Size(84, 30),
                              padding: EdgeInsets.zero,
                              shape: AppShape.sm,
                            ),
                            child: Text(context.appLocalizations.updateAll),
                          ),
                        ],
                      ),
                    ),
                    const Expanded(child: DesktopResourceItems()),
                    if (updateHours != null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                        child: Text(
                          context.appLocalizations.desktopResourceUpdateNote(
                            updateHours,
                          ),
                          style: AppTextStyle.caption1
                              .of(context)
                              .copyWith(
                                color: context.colorScheme.onSurfaceVariant,
                              ),
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

String _upstreamLabel(String value) {
  final uri = Uri.tryParse(value);
  if (uri == null || uri.host.isEmpty) return value;
  final scheme = uri.scheme.toLowerCase();
  final protocol = switch (scheme) {
    'https' => 'DoH',
    'tls' => 'DoT',
    'quic' => 'DoQ',
    _ => scheme,
  };
  return '$protocol · ${uri.host}';
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: ShapeDecoration(
      color: context.colorScheme.surface,
      shape: AppShape.xl,
      shadows: [
        BoxShadow(
          color: context.colorScheme.onSurface.withValues(alpha: 0.06),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: ClipPath(
      clipper: const ShapeBorderClipper(shape: AppShape.xl),
      child: child,
    ),
  );
}

class _HeaderLabel extends StatelessWidget {
  const _HeaderLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.only(start: 12),
    child: Text(
      label,
      style: AppTextStyle.caption1
          .of(context)
          .copyWith(color: context.colorScheme.onSurfaceVariant),
    ),
  );
}

class _HeaderChip extends StatelessWidget {
  const _HeaderChip(this.label, {this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: ShapeDecoration(
      color: selected
          ? context.colorScheme.primaryContainer
          : context.colorScheme.surfaceContainer,
      shape: AppShape.full,
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Text(
        label,
        style: AppTextStyle.caption1
            .of(context)
            .copyWith(
              color: selected
                  ? context.colorScheme.onPrimaryContainer
                  : context.colorScheme.onSurface,
            ),
      ),
    ),
  );
}
