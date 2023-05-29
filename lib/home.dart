import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_management_system_v2/cubits/drawer_cubit/drawer_cubit.dart';
import 'package:note_management_system_v2/cubits/signin_cubit/signin_cubit.dart';
import 'package:note_management_system_v2/models/user.dart';
import 'package:note_management_system_v2/screens/category_screen.dart';
import 'package:note_management_system_v2/screens/change_password_screen.dart';
import 'package:note_management_system_v2/screens/dashboard_screen.dart';
import 'package:note_management_system_v2/screens/edit_profile_screen.dart';
import 'package:note_management_system_v2/screens/note_screen.dart';
import 'package:note_management_system_v2/screens/priority_screen.dart';
import 'package:note_management_system_v2/screens/status_screen.dart';

class HomeScreen extends StatelessWidget {
  final User? user;

  const HomeScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DrawerCubit(),
      child: _HomePage(
        user: user!,
      ),
    );
  }
}

class _HomePage extends StatelessWidget {
  final User user;

  _HomePage({super.key, required this.user});

  final List<String> titles = [
    'Dashboard Form',
    'Category Form',
    'Priority Form',
    'Status Form',
    'Note Form',
    'Edit Profile Form',
    'Change Password Form'
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = [
      const DashboardScreen(),
      CategoryScreen(
        user: user,
      ),
      PriorityScreen(
        user: user,
      ),
      StatusScreen(user: user),
      NoteScreen(
        user: user,
      ),
      const EditProfileScreen(),
      const ChangePasswordScreen(),
    ];

    return Scaffold(
      endDrawerEnableOpenDragGesture: false,
      appBar: AppBar(
        title: BlocBuilder<DrawerCubit, int>(
          builder: (context, state) {
            return Text(titles[state]);
          },
        ),
      ),
      body: BlocBuilder<DrawerCubit, int>(
        builder: (context, state) {
          // Thêm trang ngay đây
          return widgets[state];
        },
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text('Note Management System'),
              accountEmail: Text(user.email!),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.asset('assets/images/profile.png'),
                ),
              ),
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Home'),
              onTap: () {
                context.read<DrawerCubit>().changeItem(0);
                context.read<DrawerCubit>().closeDrawer(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Category'),
              onTap: () {
                context.read<DrawerCubit>().changeItem(1);
                context.read<DrawerCubit>().closeDrawer(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_collection_rounded),
              title: const Text('Priority'),
              onTap: () {
                context.read<DrawerCubit>().changeItem(2);
                context.read<DrawerCubit>().closeDrawer(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.restart_alt),
              title: const Text('Status'),
              onTap: () {
                context.read<DrawerCubit>().changeItem(3);
                context.read<DrawerCubit>().closeDrawer(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.note),
              title: const Text('Note'),
              onTap: () {
                context.read<DrawerCubit>().changeItem(4);
                context.read<DrawerCubit>().closeDrawer(context);
              },
            ),
            const Divider(),
            Container(
              margin: const EdgeInsets.all(15),
              child: const Text('Account'),
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Edit Profile'),
              onTap: () {
                context.read<DrawerCubit>().changeItem(5);
                context.read<DrawerCubit>().closeDrawer(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.send),
              title: const Text('Change password'),
              onTap: () {
                context.read<DrawerCubit>().changeItem(6);
                context.read<DrawerCubit>().closeDrawer(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
