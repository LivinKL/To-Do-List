import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/services/notification_service.dart';
import 'package:to_do_list/view_models/app_view_model.dart';



class TaskView extends StatelessWidget {
  const TaskView({super.key});

  

  @override
  Widget build(BuildContext context) {

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  void setReminder(String title) {
    DateTime scheduleTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute);
    NotificationService().scheduleNotification(
      title: title,
      body: 'Complete your task before it is late!',
      scheduledNotificationDateTime: scheduleTime);

  }

  Future<void> selectTime(String title, bool lightMode) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: ThemeData(
          colorScheme: lightMode ? const ColorScheme.light(primary: Colors.black) : const ColorScheme.dark(primary: Colors.white)
        ),
        child: child!)
    );

    if (pickedTime != null) {
      selectedTime = pickedTime;
      setReminder(title);
      //schedule notification from here
    }
  }

  Future<void> selectDate(String title, bool lightMode) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: ThemeData(
          colorScheme: lightMode ? const ColorScheme.light(primary: Colors.black) : const ColorScheme.dark(primary: Colors.white)
        ),
        child: child!)
    );

    if (pickedDate != null) {
      selectedDate = pickedDate;
      selectTime(title, lightMode);
    }
  }

    return Consumer<AppViewModel>(builder: (context, viewModel, child){
      return Container(
        // padding: const EdgeInsets.only(bottom: 60),
        decoration: BoxDecoration(
          color: viewModel.clrLvl2, 
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
          child: ListView.separated(
            padding: const EdgeInsets.all(15),
             separatorBuilder: (context, index){
              return const SizedBox(height: 10,);
             },
              itemCount: viewModel.numTasks+1,
              itemBuilder: (BuildContext context, int index) {
                if (index == viewModel.numTasks) {
                  return Container(height: 50); 
                }
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction){
                    viewModel.deleteTask(index);
                  },
                  background: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.red.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Icon(Icons.delete, color: Colors.red.shade700,),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(color: viewModel.clrLvl1, borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      leading: Theme(
                        data: ThemeData(
                          unselectedWidgetColor: viewModel.clrLvl4,
                        ),
                        child: Checkbox(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(width: 2, color: viewModel.clrLvl4),
                            ),
                          checkColor: viewModel.clrLvl1,
                          activeColor: viewModel.clrLvl4,
                          value: viewModel.getTaskValue(index),
                          onChanged: (value){
                            viewModel.setTaskValue(index, value!);
                          },
                        ),
                      ),
                      title: Text(viewModel.getTaskTitle(index),
                      style: TextStyle(color: viewModel.clrLvl5, fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      trailing: InkWell(
                        onTap: (){
                          selectDate(viewModel.getTaskTitle(index),viewModel.lightMode);
                        },
                        child: Icon(Icons.notification_add_rounded, color: viewModel.clrLvl4,)
                        ),
                    ),
                  ),
                );
              },
          ),
      );
    });
  }
}