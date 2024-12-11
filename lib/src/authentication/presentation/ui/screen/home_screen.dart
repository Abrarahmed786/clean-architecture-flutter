import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/src/authentication/presentation/cubit/authentication_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void getUser() async {
    await context.read<AuthenticationCubit>().getUser();
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is UserCreated) {
          getUser();
        }
      },
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(onPressed: () {
            getUser();
          }),
          body: SafeArea(
            child: state is GettingUser
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Colors.amber,
                  ))
                : state is CreatingUser
                    ? const Center(
                        child: CircularProgressIndicator(
                        color: Colors.red,
                      ))
                    : state is UsersLoaded
                        ? ListView.builder(
                            itemCount: state.users.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    state.users[index].avatar.toString(),
                                  ),
                                ),
                                trailing: Text(
                                  state.users[index].id.toString(),
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 10,
                                  ),
                                ),
                                title: Text(
                                  state.users[index].name.toString(),
                                ),
                              );
                            },
                          )
                        : const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
