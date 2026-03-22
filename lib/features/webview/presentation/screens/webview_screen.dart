/// WebView screen for displaying web content.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/features/webview/domain/entities/webview_config.dart';
import 'package:flutter_project_template/features/webview/domain/entities/webview_state.dart';
import 'package:flutter_project_template/features/webview/presentation/providers/webview_provider.dart';
import 'package:flutter_project_template/features/webview/presentation/widgets/webview_error_widget.dart';
import 'package:flutter_project_template/features/webview/presentation/widgets/webview_loading_indicator.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// WebView screen widget.
///
/// A configurable WebView screen that supports:
/// - Dynamic URL loading
/// - Navigation controls
/// - Loading progress indicator
/// - Error handling with retry
/// - Cookie management
/// - JavaScript bridge communication
class WebViewScreen extends ConsumerStatefulWidget {
  /// Creates a WebView screen with a config object.
  const WebViewScreen({
    required this.config,
    super.key,
    this.title,
    this.showAppBar = true,
    this.enableNavigationControls = true,
  });

  /// Alternative constructor with URL.
  WebViewScreen.url({
    required String url,
    super.key,
    String? title,
    bool showAppBar = true,
    bool enableNavigationControls = true,
  })  : config = WebViewConfig(url: url),
        // ignore: prefer_initializing_formals
        title = title,
        // ignore: prefer_initializing_formals
        showAppBar = showAppBar,
        // ignore: prefer_initializing_formals
        enableNavigationControls = enableNavigationControls;

  /// The configuration for this WebView.
  final WebViewConfig config;

  /// The title to display in the AppBar.
  final String? title;

  /// Whether to show the AppBar.
  final bool showAppBar;

  /// Whether to show navigation controls.
  final bool enableNavigationControls;

  @override
  ConsumerState<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends ConsumerState<WebViewScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(webViewProvider.notifier).initialize(widget.config);
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final webViewState = ref.watch(webViewProvider);
    final webViewNotifier = ref.read(webViewProvider.notifier);
    final controller = webViewNotifier.controller;

    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).maybePop(),
                    tooltip: localizations.back,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: localizations.close,
                  ),
                ],
              ),
              leadingWidth: 96,
              title: Text(
                widget.title ??
                    webViewState.pageTitle ??
                    localizations.webViewTitle,
              ),
              actions: [
                if (widget.enableNavigationControls)
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    tooltip: localizations.webViewTitle,
                    onSelected: (value) =>
                        _handleMenuAction(value, webViewNotifier, webViewState),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'refresh',
                        child: Row(
                          children: [
                            const Icon(Icons.refresh),
                            const SizedBox(width: 12),
                            Text(localizations.webViewRefresh),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'forward',
                        enabled: webViewState.canGoForward,
                        child: Row(
                          children: [
                            const Icon(Icons.arrow_forward),
                            const SizedBox(width: 12),
                            Text(localizations.webViewForward),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem(
                        value: 'clearCache',
                        child: Row(
                          children: [
                            const Icon(Icons.cleaning_services),
                            const SizedBox(width: 12),
                            Text(localizations.webViewClearCache),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'openInBrowser',
                        child: Row(
                          children: [
                            const Icon(Icons.open_in_browser),
                            const SizedBox(width: 12),
                            Text(localizations.webViewOpenInBrowser),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'copyUrl',
                        child: Row(
                          children: [
                            const Icon(Icons.link),
                            const SizedBox(width: 12),
                            Text(localizations.webViewCopyUrl),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            )
          : null,
      body: _buildBody(
        context,
        localizations,
        webViewState,
        webViewNotifier,
        controller,
      ),
    );
  }

  void _handleMenuAction(
    String action,
    WebViewNotifier webViewNotifier,
    WebViewState webViewState,
  ) {
    switch (action) {
      case 'refresh':
        webViewNotifier.reload();
        break;
      case 'forward':
        webViewNotifier.goForward();
        break;
      case 'clearCache':
        webViewNotifier.clearCache();
        break;
      case 'openInBrowser':
        webViewNotifier.openInBrowser();
        break;
      case 'copyUrl':
        webViewNotifier.copyCurrentUrl();
        break;
    }
  }

  Widget _buildBody(
    BuildContext context,
    AppLocalizations localizations,
    WebViewState webViewState,
    WebViewNotifier webViewNotifier,
    WebViewController? controller,
  ) {
    if (webViewState.hasError) {
      return WebViewErrorWidget(
        errorMessage: webViewState.errorMessage ?? localizations.webViewError,
        errorCode: webViewState.errorCode,
        onRetry: () => webViewNotifier.reload(),
      );
    }

    if (controller == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(localizations.loading),
          ],
        ),
      );
    }

    return Stack(
      children: [
        WebViewWidget(controller: controller),
        if (webViewState.isLoading)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child:
                WebViewLoadingIndicator(progress: webViewState.loadingProgress),
          ),
      ],
    );
  }
}
