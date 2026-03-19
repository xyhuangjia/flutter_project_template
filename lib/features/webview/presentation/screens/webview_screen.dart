/// WebView screen for displaying web content.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/features/webview/domain/entities/webview_config.dart';
import 'package:flutter_project_template/features/webview/domain/entities/webview_state.dart';
import 'package:flutter_project_template/features/webview/presentation/providers/webview_provider.dart';
import 'package:flutter_project_template/features/webview/presentation/widgets/webview_error_widget.dart';
import 'package:flutter_project_template/features/webview/presentation/widgets/webview_loading_indicator.dart';
import 'package:flutter_project_template/features/webview/presentation/widgets/webview_navigation_controls.dart';
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
    super.key,
    required this.config,
    this.title,
    this.showAppBar = true,
    this.enableNavigationControls = true,
  });

  /// Alternative constructor with URL.
  WebViewScreen.url({
    super.key,
    required String url,
    String? title,
    bool showAppBar = true,
    bool enableNavigationControls = true,
  })  : config = WebViewConfig(url: url),
        title = title,
        showAppBar = showAppBar,
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
      ref.read(webViewNotifierProvider.notifier).initialize(widget.config);
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final webViewState = ref.watch(webViewNotifierProvider);
    final webViewNotifier = ref.read(webViewNotifierProvider.notifier);
    final controller = webViewNotifier.controller;

    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: Text(
                widget.title ??
                    webViewState.pageTitle ??
                    localizations.webViewTitle,
              ),
              actions: [
                if (widget.enableNavigationControls)
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    tooltip: localizations.webViewRefresh,
                    onPressed: () => webViewNotifier.reload(),
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
      bottomNavigationBar: widget.enableNavigationControls
          ? WebViewNavigationControls(
              canGoBack: webViewState.canGoBack,
              canGoForward: webViewState.canGoForward,
              onBack: () => webViewNotifier.goBack(),
              onForward: () => webViewNotifier.goForward(),
              onRefresh: () => webViewNotifier.reload(),
            )
          : null,
    );
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
