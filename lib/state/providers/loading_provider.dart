import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_clone/state/auth/provider/auth.dart';
import 'package:whats_clone/state/image_upload/model/upload_state.dart';
import 'package:whats_clone/state/image_upload/provider/image_picker_provider.dart';
import 'package:whats_clone/state/profile/models/profile_state.dart';
import 'package:whats_clone/state/profile/providers/profile_provider.dart';
import 'package:whats_clone/state/providers/app_initializer.dart';

final loadingProvider = Provider<bool>((ref) =>
        ref.watch(authProvider).isLoading ||
        ref.watch(profileNotifierProvider).status == ProfileStatus.loading||
        ref.watch(imagePickerProvider).status == UploadStatus.loading||
        ref.watch(appInitializerProvider)


    // ref.watch(imagePickerProvider) != null ||
    // ||ref.watch(contactsProvider).isLoading ||
    // ref.watch(chatProvider).isLoading
    );
