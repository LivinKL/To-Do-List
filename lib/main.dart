import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:to_do_list/services/shared_preferences.dart';
import 'package:to_do_list/view_models/app_view_model.dart';
import 'package:to_do_list/views/task_page.dart';
import 'services/notification_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageServices.init();
  NotificationService().initNotification();
  tz.initializeTimeZones();
  AppViewModel appViewModel = AppViewModel();
  await appViewModel.loadTasks();
  runApp(ChangeNotifierProvider(create:(context) => appViewModel, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To Do App',
      // theme: ThemeData.light(),
      home: TaskPage(),
    );
  }
}