import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/core/services/injection_container.dart';
import 'package:project/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:project/src/authentication/presentation/bloc/authentication_event.dart';
import 'package:project/src/authentication/presentation/cubit/authentication_cubit.dart'
    as auth_cubit;
import 'package:project/src/authentication/presentation/ui/screen/cubit_users_screen.dart';
import 'package:project/src/authentication/presentation/ui/widgets/create_user_sheet.dart';
import 'package:project/src/authentication/presentation/ui/widgets/user_list_body.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AuthenticationBloc>().add(const GetUserEvent());
      }
    });
  }

  void _loadUsers() {
    context.read<AuthenticationBloc>().add(const GetUserEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is UserCreated) {
          _loadUsers();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Users'),
            actions: [
              IconButton(
                icon: const Icon(Icons.person_add_outlined),
                tooltip: 'Create user',
                onPressed: () => showCreateUserSheet(
                      context,
                      onSubmit: ({required createdAt, required name, required avatar}) {
                        context.read<AuthenticationBloc>().add(
                              CreateUserEvents(
                                createdAt: createdAt,
                                name: name,
                                avatar: avatar,
                              ),
                            );
                      },
                    ),
              ),
            ],
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  child: Text(
                    'Navigation',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.hub_outlined),
                  title: const Text('Bloc (this screen)'),
                  selected: true,
                  onTap: () => Navigator.of(context).pop(),
                ),
                ListTile(
                  leading: const Icon(Icons.widgets_outlined),
                  title: const Text('Cubit implementation'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push<void>(
                      MaterialPageRoute<void>(
                        builder: (_) => BlocProvider<auth_cubit.AuthenticationCubit>(
                          create: (_) => sl<auth_cubit.AuthenticationCubit>(),
                          child: const CubitUsersScreen(),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _loadUsers,
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
