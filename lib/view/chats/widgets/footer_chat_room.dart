import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whats_clone/view/constants/icons_assets.dart';

final draftText = StateProvider.autoDispose<String>((ref) => '');

class FooterChatRoom extends ConsumerWidget {
  const FooterChatRoom(this.onSend, {super.key});

  final VoidCallback onSend;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = ref.watch(draftText);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Row(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: TextField(
              onChanged: (value) => ref.read(draftText.notifier).state = value,
              autofocus: true,
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          IconButton(
              onPressed: (text.isEmpty) ? null : onSend,
              icon: SvgPicture.asset(
                IconsAssets.send,
                height: 18,
                width: 18,
                colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.primary, BlendMode.srcIn),
              ))
        ],
      ),
    );
  }
}
