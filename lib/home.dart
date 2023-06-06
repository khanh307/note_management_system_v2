import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:note_management_system_v2/Localization/language.dart';
import 'package:note_management_system_v2/Localization/language_constant.dart';
import 'package:note_management_system_v2/cubits/drawer_cubit/drawer_cubit.dart';
import 'package:note_management_system_v2/main.dart';
import 'package:note_management_system_v2/models/account.dart';
import 'package:note_management_system_v2/screens/category_screen.dart';
import 'package:note_management_system_v2/screens/change_password_screen.dart';
import 'package:note_management_system_v2/screens/dashboard_screen.dart';
import 'package:note_management_system_v2/screens/edit_profile_screen.dart';
import 'package:note_management_system_v2/screens/note_screen.dart';
import 'package:note_management_system_v2/screens/priority_screen.dart';
import 'package:note_management_system_v2/screens/signin_screen.dart';
import 'package:note_management_system_v2/screens/status_screen.dart';

class HomeScreen extends StatelessWidget {
  final Account? account;
  final bool isGoogleSignIn; // Thêm biến để xác định phương thức đăng nhập

  const HomeScreen({Key? key, this.account, this.isGoogleSignIn = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => DrawerCubit(),
        child: _HomePage(account: account!, isGoogleSignIn: isGoogleSignIn));
  }
}

class _HomePage extends StatelessWidget {
  final Account account;
  final bool isGoogleSignIn; // Thêm biến để xác định phương thức đăng nhập

  _HomePage({Key? key, required this.account, required this.isGoogleSignIn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> titles = [
      translation(context).dashboard,
      translation(context).category,
      translation(context).prio,
      translation(context).status,
      translation(context).note,
      translation(context).editProfile,
      translation(context).changePass,
    ];

    final List<Widget> widgets = [
      DashboardScreen(
        user: account,
      ),
      CategoryScreen(
        user: account,
      ),
      PriorityScreen(
        user: account,
      ),
      StatusScreen(user: account),
      NoteScreen(
        user: account,
      ),
      EditProfileScreen(user: account),
      ChangePasswordScreen(user: account),
    ];

    return Scaffold(
      endDrawerEnableOpenDragGesture: false,
      appBar: AppBar(
        title: BlocBuilder<DrawerCubit, int>(
          builder: (context, state) {
            return Text(titles[state]);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: DropdownButton<Language>(
              underline: const SizedBox(),
              icon: const Icon(
                Icons.g_translate,
                color: Colors.white,
              ),
              onChanged: (Language? language) async {
                if (language != null) {
                  Locale localex = await setLocale(language.languageCode);
                  MyApp.setLocale(context, localex);
                }
              },
              items: Language.languageList()
                  .map<DropdownMenuItem<Language>>(
                    (e) => DropdownMenuItem<Language>(
                      value: e,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            e.flag,
                            style: const TextStyle(fontSize: 30),
                          ),
                          Text(e.name)
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          )
        ],
      ),
      body: BlocBuilder<DrawerCubit, int>(
        builder: (context, state) {
          // Thêm trang ngay đây
          return widgets[state];
        },
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(translation(context).note_system),
              accountEmail: Text(account.email!),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: account.photoUrl != null
                      ? Image.network(account.photoUrl!)
                      : Image.asset('assets/images/profile.png'),
                ),
              ),
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              selected: context.watch<DrawerCubit>().state == 0,
              tileColor: context.watch<DrawerCubit>().state == 0
                  ? Colors.blue
                  : Colors.white,
              leading: const Icon(Icons.camera_alt),
              title: Text(translation(context).home),
              onTap: () {
                context.read<DrawerCubit>().changeItem(0);
                context.read<DrawerCubit>().closeDrawer(context);
              },
            ),
            ListTile(
              selected: context.watch<DrawerCubit>().state == 1,
              tileColor: context.watch<DrawerCubit>().state == 1
                  ? Colors.blue
                  : Colors.white,
              leading: const Icon(Icons.photo_library),
              title: Text(translation(context).category),
              onTap: () {
                context.read<DrawerCubit>().changeItem(1);
                context.read<DrawerCubit>().closeDrawer(context);
              },
            ),
            ListTile(
              selected: context.watch<DrawerCubit>().state == 2,
              tileColor: context.watch<DrawerCubit>().state == 2
                  ? Colors.blue
                  : Colors.white,
              leading: const Icon(Icons.video_collection_rounded),
              title: Text(translation(context).prio),
              onTap: () {
                context.read<DrawerCubit>().changeItem(2);
                context.read<DrawerCubit>().closeDrawer(context);
              },
            ),
            ListTile(
              selected: context.watch<DrawerCubit>().state == 3,
              tileColor: context.watch<DrawerCubit>().state == 3
                  ? Colors.blue
                  : Colors.white,
              leading: const Icon(Icons.restart_alt),
              title: Text(translation(context).status),
              onTap: () {
                context.read<DrawerCubit>().changeItem(3);
                context.read<DrawerCubit>().closeDrawer(context);
              },
            ),
            ListTile(
              selected: context.watch<DrawerCubit>().state == 4,
              tileColor: context.watch<DrawerCubit>().state == 4
                  ? Colors.blue
                  : Colors.white,
              leading: const Icon(Icons.note),
              title: Text(translation(context).note),
              onTap: () {
                context.read<DrawerCubit>().changeItem(4);
                context.read<DrawerCubit>().closeDrawer(context);
              },
            ),
            const Divider(),
            Container(
              margin: const EdgeInsets.all(15),
              child: Text(translation(context).acc),
            ),
            Visibility(
              visible: !isGoogleSignIn,
              child: ListTile(
                selected: context.watch<DrawerCubit>().state == 5,
                tileColor: context.watch<DrawerCubit>().state == 5
                    ? Colors.blue
                    : Colors.white,
                leading: const Icon(Icons.share),
                title: Text(translation(context).editProfile),
                onTap: () {
                  context.read<DrawerCubit>().changeItem(5);
                  context.read<DrawerCubit>().closeDrawer(context);
                },
              ),
            ),
            Visibility(
              visible: !isGoogleSignIn,
              child: ListTile(
                selected: context.watch<DrawerCubit>().state == 6,
                tileColor: context.watch<DrawerCubit>().state == 6
                    ? Colors.blue
                    : Colors.white,
                leading: const Icon(Icons.send),
                title: Text(translation(context).changePass),
                onTap: () {
                  context.read<DrawerCubit>().changeItem(6);
                  context.read<DrawerCubit>().closeDrawer(context);
                },
              ),
            ),
            ListTile(
              selected: context.watch<DrawerCubit>().state == 7,
              tileColor: context.watch<DrawerCubit>().state == 7
                  ? Colors.blue
                  : Colors.white,
              leading: const Icon(Icons.logout),
              title: Text(translation(context).logOut),
              onTap: () {
                if (isGoogleSignIn) {
                  GoogleSignIn().signOut();
                }
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInHome()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
