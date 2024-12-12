import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_clone/state/contacts/backend/contact_service.dart';
import 'package:whats_clone/state/contacts/model/app_contact.dart';
import 'package:whats_clone/state/contacts/notifier/contact_notifier.dart';

final contactServicesProvider = Provider((ref) => ContactServices());

final contactNotifierProvider =
    StateNotifierProvider<ContactNotifier, AsyncValue<List<AppContact>>>((ref) {
  final contactServices = ref.watch(contactServicesProvider);
  return ContactNotifier(contactServices);
});
