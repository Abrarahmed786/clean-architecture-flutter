import 'package:flutter/material.dart';
import 'package:project/src/authentication/domain/entities/user.dart';

/// Layout-only widget so Bloc and Cubit can each keep their own [AuthenticationState]
/// types (via `part` files) without a shared library.
class UserListBody extends StatelessWidget {
  const UserListBody({
    super.key,
    required this.showLoadingGetting,
    required this.showLoadingCreating,
    required this.usersWhenLoaded,
  });

  final bool showLoadingGetting;
  final bool showLoadingCreating;
  final List<User>? usersWhenLoaded;

  @override
  Widget build(BuildContext context) {
    if (showLoadingGetting) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.amber),
      );
    }
    if (showLoadingCreating) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.red),
      );
    }
    if (usersWhenLoaded != null) {
      final users = usersWhenLoaded!;
      return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) => UserTile(user: users[index]),
      );
    }
    return const SizedBox.shrink();
  }
}

class UserTile extends StatelessWidget {
  const UserTile({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final avatarUrl = user.avatar;
    return ListTile(
      leading: CircleAvatar(
        child: avatarUrl == null || avatarUrl.isEmpty
            ? const Icon(Icons.person)
            : ClipOval(
                child: Image.network(
                  avatarUrl,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  cacheWidth: 96,
                  cacheHeight: 96,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                ),
              ),
      ),
      trailing: Text(
        user.id ?? '',
        style: const TextStyle(color: Colors.red, fontSize: 10),
      ),
      title: Text(user.name ?? ''),
    );
  }
}
