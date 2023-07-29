import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/view_models/add_task_view.dart';
import 'package:to_do_list/views/header_view.dart';
import 'package:to_do_list/views/task_info_view.dart';
import 'package:to_do_list/views/task_list_view.dart';
import '../view_models/app_view_model.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppViewModel>(builder: (context, viewModel, child){
      return Scaffold(
        backgroundColor: viewModel.lightMode ? Colors.white : Colors.black,
        body: SafeArea(
          bottom: false, // to avoid the bottom area only notch part
          child: Column(
            children:const  [
              Expanded(flex: 1, child: HeaderView()),
              Expanded(flex: 1, child: TaskInfoView(),),
              Expanded(flex: 7, child: TaskView())
            ],
          ),
        ),
        floatingActionButton: const AddTaskView(),
      );
  });
  }
}