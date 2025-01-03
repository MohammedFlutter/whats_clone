import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_clone/state/contacts/model/app_contact.dart';
import 'package:whats_clone/state/contacts/providers/contacts_provider.dart';
import 'package:whats_clone/view/constants/strings.dart';
import 'package:whats_clone/view/contacts/widgets/contact_card.dart';

class ContactPage extends ConsumerStatefulWidget {
  const ContactPage({super.key});

  @override
  ConsumerState<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends ConsumerState<ContactPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  void _loadContacts() {
    Future.microtask(() {
      ref.read(allContactsProvider.notifier).loadContacts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(Strings.contacts)),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildContactListView()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search contacts...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  Widget _buildContactListView() {
    return RefreshIndicator(
      onRefresh: () => ref.refresh(allContactsProvider.notifier).loadContacts(),
      child: Consumer(
        builder: (context, ref, _) {
          final searchQuery = _searchController.text;
          final contactsProvider = searchQuery.isEmpty
              ? allContactsProvider
              : searchContactsProvider(searchQuery);

          return ref.watch(contactsProvider).when(
            data: _buildContactList,
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('Error: $error')),
          );
        },
      ),
    );
  }

  Widget _buildContactList(List<AppContact> contacts) {
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
          _buildSectionHeader(Strings.contactOnApp),
          _buildContactSection(registered, _handleRegisteredContact),
        ],
        if (unregistered.isNotEmpty) ...[
          _buildSectionHeader(Strings.inviteToApp),
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
            (context, index) => ContactCard(
          contact: contacts[index],
          onPressed: () => onPressed(contacts[index]),
        ),
      ),
    );
  }

  void _handleRegisteredContact(AppContact contact) {
    // TODO: Navigate to chat or contact details
  }

  void _handleUnregisteredContact(AppContact contact) {
    // TODO: Deep link to invite screen
  }
}