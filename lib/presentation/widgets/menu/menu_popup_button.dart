import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:solidarity_app/application/core/local_service.dart';
import 'package:solidarity_app/application/user/user_bloc.dart';
import 'package:solidarity_app/domain/user/user.dart';
import 'package:solidarity_app/domain/user/user_settings.dart';
import 'package:solidarity_app/presentation/core/constants.dart';
import 'package:solidarity_app/presentation/core/helper.dart';
import 'package:solidarity_app/presentation/core/menu_item.dart';
import 'package:solidarity_app/presentation/core/screens.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solidarity_app/presentation/core/version.dart';
import 'package:solidarity_app/presentation/dialogs/confirmation_dialog.dart';
import 'package:solidarity_app/presentation/dialogs/membership_codes_dialog.dart';
import 'package:solidarity_app/presentation/widgets/all_widgets.dart';


class MenuPopUpButton extends StatefulWidget {
  _MenuState createState()=>_MenuState();
}

class _MenuState extends State<MenuPopUpButton>{
  List<MenuItem> menuItems=[];

  _populateMenuItems(){
    menuItems = [

      MenuItem(0,'Users',Icons.people),
      MenuItem(1,'Profile',Icons.person),
      MenuItem(3, 'Membership Codes', Icons.code),
      MenuItem(4, 'Logout', Icons.logout),
      MenuItem(5, 'About', Icons.info)
    ];
    //now add the theme item
    UserSettings settings = context.read<LocalService>().userSettings!;
    MenuItem item;
    if(settings.themeMode==ThemeMode.dark){
      item = MenuItem(2,'Light Theme',Icons.wb_sunny);
    }else{
      item = MenuItem(2,'Dark Theme',Icons.mode_night);
    }
    menuItems.insert(2,item,);
  }
  _onMenuItemSelected(MenuItem item)async{
    if(item.index==0){
      ///load users
      var user = await Navigator.pushNamed(context, Screens.USER_LIST);
      if(user!=null){
        context.read<UserBloc>().setSelectedUser(user as User);
        Helper.navigate(context, Screens.USER_DETAILS);
      }
    }else if(item.index==1){
      //open profile
      Helper.navigate(context, Screens.USER_PROFILE);
    }else if(item.index==2){
      UserSettings settings = context.read<LocalService>().userSettings!;
      //change theme
      if(settings.themeMode==ThemeMode.dark){
        settings.themeMode=ThemeMode.light;
      }else{
        settings.themeMode=ThemeMode.dark;
      }
      context.read<LocalService>().saveUserSettings(context, settings);
      _populateMenuItems();
      EasyDynamicTheme.of(context).changeTheme(dark: settings.themeMode==ThemeMode.dark);

    }else if(item.index==3){
      showDialog(context: context, builder: (_)=>MembershipCodesDialog());
    }else if(item.index==4){
     bool _confirmed = await Helper.getConfirmation(context, ConfirmationDialog(
       'Are you sure to logout? You\'ll need to provide your Membership Code to login again ',
       positiveButtonText: 'Yes, logout',
       negativeButtonText: 'No, stay in',
     ));
     if(_confirmed){
       context.read<UserBloc>().add(LogOutEvent());
     }
    }else if(item.index==5){
      Version version = await context.read<LocalService>().getPackageName();
      showAboutDialog(context: context,
      applicationIcon: AppIcon(),
      applicationName: Constants.APP_NAME,
      applicationVersion:version.version,
      children: [
        LightText('Developed by goodONE')
      ]);
    }
  }



  void initState(){
    super.initState();
    _populateMenuItems();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context,state){
        if( state is LogOutCompleteState){
          if(state.result.success){
            Helper.navigate(context, Screens.LOGIN,pushReplace: true);
          }else{
            Helper.showSnackBar(context, state.result.userMessage!,error: true);
          }
        }
      },
      child: PopupMenuButton<MenuItem>(
        onSelected: (item){
          _onMenuItemSelected(item);
        },
        itemBuilder: (context){
          return menuItems.map((item){
            return PopupMenuItem(
              value: item,
              child: MenuItemWidget(item),
            );
          }).toList();
        },
      ),
    );
  }
}
