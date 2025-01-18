import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_clone/core/theme/app_colors.dart';
import 'package:whats_clone/state/auth/provider/auth.dart';
import 'package:whats_clone/state/message/models/message.dart';

class MessageCard extends ConsumerWidget {
  const MessageCard({
    super.key,
    required this.message,
  });

  final Message message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final isCurrentUser = ref.watch(authProvider).userId! == message.senderId;

    final textColor = isLight
        ? isCurrentUser
            ? AppColors.textPrimary
            : AppColors.surface
        : AppColors.offWhite;
    final cardColor = isCurrentUser
        ? Theme.of(context).colorScheme.surfaceContainerHigh
        : Theme.of(context).colorScheme.primary;

    return Row(
      children: [
        Expanded(
          child: Align(
            alignment: isCurrentUser
                ? AlignmentDirectional.centerStart
                : AlignmentDirectional.centerEnd,
            child: Card(
              elevation: 0,
              color: cardColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.only(
                      topEnd: _radius,
                      topStart: _radius,
                      bottomStart: isCurrentUser ? Radius.zero : _radius,
                      bottomEnd: isCurrentUser ? _radius : Radius.zero)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  message.content,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: textColor),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

const _radius = Radius.circular(16);
