import 'package:flutter/material.dart';
import 'package:to_do_list/models/task_model.dart';
import 'package:to_do_list/models/user_model.dart';
import 'package:to_do_list/services/database_service.dart';
import 'package:to_do_list/services/shared_preferences.dart';

class AppViewModel extends ChangeNotifier{

  DatabaseService db = DatabaseService.instance;

  List<Task> tasks = <Task>[];
  List<Task> temp = <Task>[];
  User user = User(StorageServices.getUsername());

  bool _showTotal = true;
  bool _lightMode = StorageServices.getLightMode();
  

  Color clrLvl1 = Colors.grey.shade50;
  Color clrLvl2 = Colors.grey.shade200;
  Color clrLvl3 = Colors.grey.shade400;
  Color clrLvl4 = Colors.grey.shade800;
  Color clrLvl5 = Colors.grey.shade900;

  int get numTasks => tasks.length;

  int get totalTasks => temp.length;

  int get numTasksRemaining => temp.where((task) => !task.complete).length;

  String get username => user.username;

  bool get showTotal => _showTotal;

  bool get lightMode => _lightMode;

  Future<void> loadTasks() async {
    final dataList = await db.getAllData();
    // db.printDataFromDatabase();
    for (final data in dataList) {
      tasks.add(Task(data['task'], data['complete']=='true', data['id']));
    }
    temp = List<Task>.from(tasks);

    if (!_lightMode){
      clrLvl1 = Colors.grey.shade900;
      clrLvl2 = Colors.grey.shade800;
      clrLvl3 = Colors.grey.shade600;
      clrLvl4 = Colors.grey.shade200;
      clrLvl5 = Colors.grey.shade50;
    }
    notifyListeners();
  }

  void addTask(Task newTask){
    tasks.add(newTask);
    temp.add(newTask);
    db.addToList(newTask);
    notifyListeners();
  }

  bool getTaskValue(int taskIndex){
    return tasks[taskIndex].complete;
  }

  String getTaskTitle(int taskIndex){
    return tasks[taskIndex].title;
  }

  int getIndexByTaskId(int taskId) {
    for (int i = 0; i < temp.length; i++) {
      if (temp[i].task_ID == taskId) {
        return i;
      }
    }
    return -1; // Return -1 if no matching task is found
  }

  void setTaskValue(int taskIndex, bool taskValue){
    db.updateData(tasks[taskIndex].task_ID, taskValue);

    if (showTotal){
      tasks[taskIndex].complete = taskValue;
      temp[taskIndex].complete = taskValue;
    }
    else{
      int index = getIndexByTaskId(tasks[taskIndex].task_ID);
      tasks.removeAt(taskIndex);
      temp[index].complete = taskValue;
    }
    notifyListeners();
  }

  void updateUsername(String newUsername){
    user.username = newUsername;
    StorageServices.setUsername(newUsername);
    notifyListeners();
  }


  void deleteTask(int taskIndex) async {
    await db.deleteTask(tasks[taskIndex].task_ID);

    int index = showTotal ? taskIndex : getIndexByTaskId(tasks[taskIndex].task_ID);
    temp.removeAt(index);
    tasks.removeAt(taskIndex);
    notifyListeners();
  }

  void deleteAllTasks(){
    db.deleteAllData();
    tasks.clear();
    temp.clear();
    notifyListeners();
  }

  void deleteCompletedTasks(){
    db.deleteCompletedTasks();

    temp = temp.where((task) => !task.complete,).toList();
    if (showTotal){
      tasks = tasks.where((task) => !task.complete,).toList();
    }
    
    notifyListeners();
  }

  void getAllTask(){
    _showTotal = true;
    tasks = List<Task>.from(temp);
    notifyListeners();
  }

  void getRemainingTask(){
    _showTotal = false;
    tasks = temp.where((element) => element.complete == false).toList();
    notifyListeners();
  }

  void changeTheme() {

    if (_lightMode){
      clrLvl1 = Colors.grey.shade900;
      clrLvl2 = Colors.grey.shade800;
      clrLvl3 = Colors.grey.shade600;
      clrLvl4 = Colors.grey.shade200;
      clrLvl5 = Colors.grey.shade50;
      StorageServices.changeLightMode();
      _lightMode = false;
    }
    else{
      clrLvl1 = Colors.grey.shade50;
      clrLvl2 = Colors.grey.shade200;
      clrLvl3 = Colors.grey.shade400;
      clrLvl4 = Colors.grey.shade800;
      clrLvl5 = Colors.grey.shade900;
      StorageServices.changeLightMode();
      _lightMode = true;
    }

    notifyListeners();
  }

  void bottomSheetBuilder(Widget bottomsheetView, BuildContext context){
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40))),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      builder: ((context) {
         return bottomsheetView;
       }
      )
    );
  }

}