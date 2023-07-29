import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/view_models/app_view_model.dart';
import 'package:to_do_list/views/bottom_sheets/delete_bottom_sheet.dart';
import 'bottom_sheets/settings_bottom_sheet_view.dart';

class HeaderView extends StatelessWidget {
  const HeaderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppViewModel>(builder: (context, viewModel, child){
      return Row(
        children: [
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: (){
                viewModel.bottomSheetBuilder(const SettingsBottomSheetView(), context);
              },
              child: Container(
                margin: const EdgeInsets.only(left: 20, top: 10),
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Text("Welcome Back,",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: viewModel.clrLvl5),),
                        ),
                      ),
                    ),
                
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Text(viewModel.username,
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: viewModel.clrLvl5),),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )),
            Expanded(
            flex: 1,
            child: InkWell(
              onTap: (){
                viewModel.bottomSheetBuilder(const DeleteBottomSheetView(), context);
              },
              child: Icon(Icons.delete, color: viewModel.clrLvl4, size: 30,))),
            Expanded(
            flex: 1,
            child: InkWell(
              onTap: (){
                viewModel.changeTheme();
              },
              child: Icon(viewModel.lightMode ? Icons.dark_mode : Icons.light_mode_rounded, color: viewModel.clrLvl4, size: 30,))),
        ],
      );
    });
  }
}