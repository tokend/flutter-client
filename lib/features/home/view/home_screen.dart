import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/features/home/logic/drawer_bloc.dart';
import 'package:flutter_template/features/home/logic/drawer_state.dart';
import 'package:flutter_template/features/home/view/drawer_content.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocProvider<DrawerBloc>(
      create: (BuildContext context) =>
          DrawerBloc(DrawerState(NavItem.dashboard)),
      child: BlocBuilder<DrawerBloc, DrawerState>(
        builder: (BuildContext context, DrawerState state) => Scaffold(
          drawer: DrawerContent("Joe Shmoe", "shmoe@joesemail.com"),
          appBar: AppBar(
            title: Text('default text'),
          ),
        ),
      ));
}
