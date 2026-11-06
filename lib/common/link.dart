import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';

import 'print.dart';
import 'protocol.dart';
import 'string.dart';

String? profileUrlFromQrCodes(Iterable<String?> values) {
  for (final value in values) {
    final text = value?.trim();
    if (text == null || text.isEmpty) {
      continue;
    }
    if (text.isUrl || text.isShareLink) {
      return text;
    }
    final uri = Uri.tryParse(text);
    if (uri == null || !protocolSchemes.contains(uri.scheme)) {
      continue;
    }
    final url = installConfigUrl(uri);
    if (url != null && url.isUrl) {
      return url;
    }
  }
  return null;
}

/// The URL an install-config link carries, or null for any other link.
String? installConfigUrl(Uri uri) {
  if (uri.host != 'install-config') {
    return null;
  }
  final url = uri.queryParameters['url']?.trim();
  return url == null || url.isEmpty ? null : url;
}

/// A pasted subscription URL, or null when the text is neither one nor an
/// install-config link to one.
String? subscriptionUrlFromText(String text) {
  final trimmed = text.trim();
  if (trimmed.isEmpty) return null;
  final uri = Uri.tryParse(trimmed);
  if (uri == null) return null;
  if (_isHttpUrl(uri)) return trimmed;
  if (!protocolSchemes.contains(uri.scheme)) return null;
  final url = installConfigUrl(uri);
  if (url == null) return null;
  final target = Uri.tryParse(url);
  return target != null && _isHttpUrl(target) ? url : null;
}

bool _isHttpUrl(Uri uri) =>
    (uri.scheme == 'http' || uri.scheme == 'https') && uri.host.isNotEmpty;

class LinkManager {
  static LinkManager? _instance;
  StreamSubscription? subscription;
  Uri? _pendingUri;

  LinkManager._internal();

  @visibleForTesting
  Stream<Uri> Function() uriLinkStream = () => AppLinks().uriLinkStream;

  /// Linux argv: the gtk plugin hooks GApplication too late to see it.
  void seedInitialLink(List<String> args) {
    for (final arg in args) {
      final uri = Uri.tryParse(arg);
      if (uri != null && protocolSchemes.contains(uri.scheme)) {
        _pendingUri = uri;
        return;
      }
    }
  }

  Future<void> initAppLinksListen(
    Function(String url) installConfigCallBack,
  ) async {
    destroy();
    subscription = uriLinkStream().listen((uri) {
      _handle(uri, installConfigCallBack);
    });
    final pending = _pendingUri;
    _pendingUri = null;
    if (pending != null) {
      _handle(pending, installConfigCallBack);
    }
  }

  void _handle(Uri uri, Function(String url) installConfigCallBack) {
    // The query carries the subscription URL, a credential: log where it
    // points, never the link itself.
    commonPrint.log('onAppLink: ${uri.scheme}://${uri.host}');
    final url = installConfigUrl(uri);
    if (url != null) {
      installConfigCallBack(url);
    }
  }

  void destroy() {
    if (subscription != null) {
      subscription?.cancel();
      subscription = null;
    }
  }

  factory LinkManager() {
    _instance ??= LinkManager._internal();
    return _instance!;
  }
}

final linkManager = LinkManager();
