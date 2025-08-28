import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:whats_clone/core/routes/route_name.dart';
import 'package:whats_clone/core/routes/route_params.dart';
import 'package:whats_clone/core/utils/extensions/localization_extension.dart';
import 'package:whats_clone/state/chat/provider/chat_provider.dart';
import 'package:whats_clone/state/contacts/model/app_contact.dart';
import 'package:whats_clone/state/contacts/providers/contacts_provider.dart';
import 'package:whats_clone/view/widgets/app_list_tile.dart';
import 'package:whats_clone/view/widgets/app_search_bar.dart';

final contactSearchQueryProvider = StateProvider<String>((ref) {
  return '';
});

class ContactPage extends ConsumerStatefulWidget {
  const ContactPage({super.key});

  @override
  ConsumerState<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends ConsumerState<ContactPage> {
  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  void _loadContacts() {
    Future.microtask(() {
      ref.read(allContactsProvider.notifier);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.contacts)),
      body: Column(
        children: [
          AppSearchBar(
            hintText: context.l10n.searchContacts,
            onChanged: (value) =>
                ref.watch(contactSearchQueryProvider.notifier).state = value,
          ),
          Expanded(child: _buildContactListView()),
        ],
      ),
    );
  }

  Widget _buildContactListView() {
    return RefreshIndicator(
      onRefresh: () =>
          ref.refresh(allContactsProvider.notifier).refreshContacts(),
      child: Consumer(
        builder: (context, ref, _) {
          final searchQuery = ref.watch(contactSearchQueryProvider);
          final contactsProvider = searchQuery.isEmpty
              ? allContactsProvider
              : searchContactsProvider;

          return ref.watch(contactsProvider).when(
                data: (contacts) => _buildContactList(context, contacts),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text(error.toString())),
              );
        },
      ),
    );
  }

  Widget _buildContactList(BuildContext context, List<AppContact> contacts) {
    if (contacts.isEmpty) {
      return const Center(child: Text('No contacts found'));
    }

    final registered = contacts.where((c) => c.isRegistered).toList();
    final unregistered = contacts.where((c) => !c.isRegistered).toList();

    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: const BouncingScrollPhysics(),
      slivers: [
        if (registered.isNotEmpty) ...[
          _buildSectionHeader(context.l10n.contactOnApp(context.l10n.appTitle)),
          _buildContactSection(registered, _handleRegisteredContact),
        ],
        if (unregistered.isNotEmpty) ...[
          _buildSectionHeader(context.l10n.inviteToApp(context.l10n.appTitle)),
          _buildContactSection(unregistered, _handleUnregisteredContact),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      sliver: SliverToBoxAdapter(
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildContactSection(
    List<AppContact> contacts,
    void Function(AppContact) onPressed,
  ) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: contacts.length,
        (context, index) => AppListTile(
          onPressed: () => onPressed(contacts[index]),
          title: contacts[index].displayName,
          subtitle: contacts[index].phoneNumbers.join(', '),
          avatarUrl: contacts[index].avatarUrl,
        ),
      ),
    );
  }

  Future<void> _handleRegisteredContact(AppContact contact) async {
    final chatProfile = await ref
        .read(chatNotifierProvider.notifier)
        .createChat(antherUserId: contact.userId!);
    if (!mounted || chatProfile == null) return;
    context.goNamed(
      RouteName.chatRoom,
      pathParameters: {
        RouteParams.chatId: chatProfile.chatId,
      },
    );
  }

  void _handleUnregisteredContact(AppContact contact) {
    // TODO: Deep link to invite screen
  }
}
