/// Conversation list screen showing all chats.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_project_template/features/chat/domain/entities/chat_message.dart';
import 'package:flutter_project_template/features/chat/presentation/providers/chat_provider.dart';
import 'package:flutter_project_template/features/chat/presentation/widgets/conversation_list_item.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';
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
    final isDark = theme.brightness == Brightness.dark;
    final conversationsAsync = ref.watch(chatNotifierProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
                decoration: InputDecoration(
                  hintText: localizations.searchConversations,
                  hintStyle: TextStyle(
                    color: isDark
                        ? const Color(0xFF64748B)
                        : const Color(0xFF94A3B8),
                  ),
                  border: InputBorder.none,
                ),
                onChanged: _performSearch,
                onSubmitted: _performSearch,
              )
            : Text(
                localizations.chats,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0,
        leading: _isSearching
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
                onPressed: _clearSearch,
              )
            : null,
        actions: [
          if (_isSearching)
            IconButton(
              icon: Icon(
                Icons.clear,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
              onPressed: _clearSearch,
            )
          else
            IconButton(
              icon: Icon(
                Icons.search,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
              onPressed: _startSearch,
            ),
        ],
      ),
      body: conversationsAsync.when(
        data: (state) {
          final conversations = state.filteredConversations;
          if (conversations.isEmpty) {
            if (_searchController.text.isNotEmpty) {
              return _buildNoSearchResultsState(isDark, localizations);
            }
            return _buildEmptyState(isDark, localizations);
          }
          return ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              return ConversationListItem(
                conversation: conversation,
                onTap: () => _navigateToChat(conversation),
                onDelete: () => _deleteConversation(conversation.id),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewConversation,
        backgroundColor: const Color(0xFF2563EB),
        child: const Icon(Icons.add_comment_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark, AppLocalizations localizations) =>
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline_rounded,
              size: 64,
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
            const SizedBox(height: 16),
            Text(
              localizations.noConversationsYet,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color:
                    isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              localizations.startNewChatHint,
              style: TextStyle(
                fontSize: 14,
                color:
                    isDark ? const Color(0xFF475569) : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      );

  Widget _buildNoSearchResultsState(
          bool isDark, AppLocalizations localizations) =>
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
            const SizedBox(height: 16),
            Text(
              localizations.noConversationsFound,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color:
                    isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              localizations.tryDifferentSearch,
              style: TextStyle(
                fontSize: 14,
                color:
                    isDark ? const Color(0xFF475569) : const Color(0xFF94A3B8),
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
