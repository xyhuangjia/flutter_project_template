/// Conversation list screen showing all chats.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_project_template/features/chat/domain/entities/chat_message.dart';
import 'package:flutter_project_template/features/chat/presentation/providers/chat_provider.dart';
import 'package:flutter_project_template/features/chat/presentation/widgets/conversation_list_item.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';
import 'package:flutter_project_template/shared/widgets/settings_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Conversation list screen.
class ConversationListScreen extends ConsumerStatefulWidget {
  /// Creates the conversation list screen.
  const ConversationListScreen({super.key});

  @override
  ConsumerState<ConversationListScreen> createState() =>
      _ConversationListScreenState();
}

class _ConversationListScreenState
    extends ConsumerState<ConversationListScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _performSearch(String query) {
    final chatNotifier = ref.read(chatNotifierProvider.notifier);
    chatNotifier.search(query.isEmpty ? null : query);
  }

  void _clearSearch() {
    _searchController.clear();
    final chatNotifier = ref.read(chatNotifierProvider.notifier);
    chatNotifier.clearSearch();
    setState(() {
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final conversationsAsync = ref.watch(chatNotifierProvider);

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: localizations.searchConversations,
                  border: InputBorder.none,
                ),
                onChanged: _performSearch,
                onSubmitted: _performSearch,
              )
            : Text(localizations.chats),
        leading: _isSearching
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _clearSearch,
              )
            : null,
        actions: [
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearSearch,
            )
          else
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _startSearch,
            ),
        ],
      ),
      body: conversationsAsync.when(
        data: (state) {
          final conversations = state.filteredConversations;
          if (conversations.isEmpty) {
            if (_searchController.text.isNotEmpty) {
              return _buildNoSearchResultsState(colorScheme, localizations);
            }
            return _buildEmptyState(colorScheme, localizations);
          }
          return _buildConversationList(conversations);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewConversation,
        backgroundColor: AppIconColors.aiColor,
        child: const Icon(Icons.add_comment_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildConversationList(List<ChatConversation> conversations) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: conversations.length,
      itemBuilder: (context, index) {
        final conversation = conversations[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ConversationListItem(
            conversation: conversation,
            onTap: () => _navigateToChat(conversation),
            onDelete: () => _deleteConversation(conversation.id),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(
          ColorScheme colorScheme, AppLocalizations localizations) =>
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppIconColors.aiColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                Icons.chat_bubble_outline_rounded,
                size: 40,
                color: AppIconColors.aiColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              localizations.noConversationsYet,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              localizations.startNewChatHint,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );

  Widget _buildNoSearchResultsState(
          ColorScheme colorScheme, AppLocalizations localizations) =>
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              localizations.noConversationsFound,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              localizations.tryDifferentSearch,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );

  void _navigateToChat(ChatConversation conversation) =>
      context.push('/chat/${conversation.id}');

  Future<void> _createNewConversation() async {
    final chatNotifier = ref.read(chatNotifierProvider.notifier);
    final localizations = AppLocalizations.of(context)!;
    final id = await chatNotifier.createConversation(localizations.newChat);
    if (mounted) {
      unawaited(context.push('/chat/$id'));
    }
  }

  Future<void> _deleteConversation(String conversationId) async {
    final chatNotifier = ref.read(chatNotifierProvider.notifier);
    await chatNotifier.deleteConversation(conversationId);
  }
}
