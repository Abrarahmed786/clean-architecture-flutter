import 'package:flutter/material.dart';

typedef CreateUserSubmit = void Function({
  required String createdAt,
  required String name,
  required String avatar,
});

Future<void> showCreateUserSheet(
  BuildContext context, {
  required CreateUserSubmit onSubmit,
}) async {
  final nameController = TextEditingController();
  final avatarController = TextEditingController();

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 8,
          bottom: MediaQuery.viewInsetsOf(sheetContext).bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Create user',
              style: Theme.of(sheetContext).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: avatarController,
              decoration: const InputDecoration(
                labelText: 'Avatar URL',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                final name = nameController.text.trim();
                final avatar = avatarController.text.trim();
                if (name.isEmpty) {
                  ScaffoldMessenger.of(sheetContext).showSnackBar(
                    const SnackBar(content: Text('Please enter a name')),
                  );
                  return;
                }
                Navigator.of(sheetContext).pop();
                onSubmit(
                  createdAt: DateTime.now().toIso8601String(),
                  name: name,
                  avatar: avatar.isEmpty
                      ? 'https://api.dicebear.com/7.x/avataaars/svg?seed=$name'
                      : avatar,
                );
              },
              child: const Text('Create'),
            ),
          ],
        ),
      );
    },
  );

  nameController.dispose();
  avatarController.dispose();
}
