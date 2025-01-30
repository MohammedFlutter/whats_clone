import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:whats_clone/state/auth/provider/auth.dart';
import 'package:whats_clone/state/user_presence/provider/user_presence_provider.dart';

class AppWrapper extends ConsumerStatefulWidget {
  const AppWrapper({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends ConsumerState<AppWrapper>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final userPresenceService = ref.read(userPresenceServiceProvider);
    final userId = ref.read(authProvider).userId;
    if (userId == null) return;


    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.detached) {
      userPresenceService.updateUserPresence(userId, isOnline: false);
    } else if (state == AppLifecycleState.resumed) {
      userPresenceService.updateUserPresence(userId, isOnline: true);
    }

    FirebaseDatabase.instance.goOnline();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
