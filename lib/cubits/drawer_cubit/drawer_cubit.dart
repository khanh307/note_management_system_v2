import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class DrawerCubit extends Cubit<int> {
  DrawerCubit() : super(0); // Initial state is the first item

  // Change the current item index
  void changeItem(int index) => emit(index);

  // Close the drawer
  void closeDrawer(BuildContext context) {
    Navigator.of(context).pop();
  }
}