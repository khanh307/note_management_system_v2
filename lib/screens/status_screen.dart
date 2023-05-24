import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_management_system_v2/cubits/status_cubit/status_cubit.dart';
import 'package:note_management_system_v2/cubits/status_cubit/status_state.dart';
import 'package:note_management_system_v2/repository/status_repository.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _StatusHome();
  }
}

class _StatusHome extends StatefulWidget {
  const _StatusHome({Key? key}) : super(key: key);

  @override
  State<_StatusHome> createState() => _StatusHomeState();
}

class _StatusHomeState extends State<_StatusHome> {
  final statusCubit = StatusCubit(StatusRepository(email: 'kyle@r2s.com.vn'));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    statusCubit.getAllStatus();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider.value(
        value: statusCubit,
        child: BlocBuilder<StatusCubit, StatusState>(
          builder: (context, state) {
            if (state is InitialStatusState || state is LoadingStatusState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is SuccessGetAllStatusState) {
              final listStatus = state.listStatus;
              return ListView.builder(
                itemCount: listStatus!.length,
                itemBuilder: (context, index) => Card(
                  color: Colors.white,
                  elevation: 5,
                  margin: const EdgeInsets.all(10),
                  child: Dismissible(
                    key: Key(listStatus[index].name!),
                    background: Container(
                      color: Colors.redAccent,
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    secondaryBackground: Container(
                      color: Colors.greenAccent,
                      child: const Icon(
                        Icons.update,
                        color: Colors.white,
                      ),
                    ),
                    onDismissed: (directory) {
                      if (directory == DismissDirection.startToEnd) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Delete')));
                      } else if (directory == DismissDirection.endToStart) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Update')));
                      }
                    },
                    child: ListTile(
                      title: Text(listStatus[index].name!),
                      subtitle: Text(listStatus[index].createdAt!),
                    ),
                  ),
                ),
              );
            }
            return Text(state.toString());
          },
        ),
      ),
    );
  }
}
