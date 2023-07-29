import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/models/task_model.dart';
import 'package:to_do_list/services/shared_preferences.dart';
import 'package:to_do_list/view_models/app_view_model.dart';

class AddTaskBottomSheetView extends StatelessWidget {
  const AddTaskBottomSheetView({super.key});

  

  @override
  Widget build(BuildContext context) {

    final TextEditingController entryController = TextEditingController();

    return Consumer<AppViewModel>(builder: (context, viewModel, child){
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: 80,
          color: viewModel.clrLvl1,
          child: SizedBox(
            height: 40,
            width: 250,
            child: TextField(
              onSubmitted: (value) {
                if (entryController.text.isNotEmpty){
                  Task newTask = Task(entryController.text, false, StorageServices.gettaskid());
                  viewModel.addTask(newTask);
                  entryController.clear();
                }
                Navigator.of(context).pop();
              },
          
              decoration: InputDecoration(contentPadding: const EdgeInsets.only(bottom: 5),
              filled: true,
              fillColor:viewModel.clrLvl2,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(width: 0, style: BorderStyle.none))
              ),
          
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
              cursorColor: viewModel.clrLvl5,
              autofocus: true,
              autocorrect: false,
              controller: entryController,
              style: TextStyle(color: viewModel.clrLvl5, fontWeight: FontWeight.w500),
            ),
          ),
          ),
      );
    });
  }
}