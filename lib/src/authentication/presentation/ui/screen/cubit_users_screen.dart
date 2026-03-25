import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/src/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:project/src/authentication/presentation/ui/widgets/create_user_sheet.dart';
import 'package:project/src/authentication/presentation/ui/widgets/user_list_body.dart';

/// Same user list flow using [AuthenticationCubit] instead of [AuthenticationBloc].
class CubitUsersScreen extends StatefulWidget {
  const CubitUsersScreen({super.key});

  @override
  State<CubitUsersScreen> createState() => _CubitUsersScreenState();
}

class _CubitUsersScreenState extends State<CubitUsersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<AuthenticationCubit>().getUser();
    });
  }

  Future<void> _refresh() async {
    await context.read<AuthenticationCubit>().getUser();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is UserCreated) {
          _refresh();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Users (Cubit)'),
            actions: [
              IconButton(
                icon: const Icon(Icons.person_add_outlined),
                tooltip: 'Create user',
                onPressed: () => showCreateUserSheet(
                      context,
                      onSubmit: ({required createdAt, required name, required avatar}) {
                        context.read<AuthenticationCubit>().createUser(
                              createdAt: createdAt,
                              name: name,
                              avatar: avatar,
                            );
                      },
                    ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _refresh,
            tooltip: 'Refresh list',
            child: const Icon(Icons.refresh),
          ),
          body: SafeArea(
            child: UserListBody(
              showLoadingGetting: state is GettingUser,
              showLoadingCreating: state is CreatingUser,
              usersWhenLoaded:
                  state is UsersLoaded ? state.users : null,
            ),
          ),
        );
      },
    );
  }
}
