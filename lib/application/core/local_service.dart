
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solidarity_app/domain/factories.dart';
import 'package:solidarity_app/domain/user/user_factory.dart';
import 'package:solidarity_app/domain/user/user_settings.dart';
import 'package:solidarity_app/presentation/core/helper.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:solidarity_app/presentation/core/version.dart';

class LocalService extends ChangeNotifier{

  UserFactory userFactory = Factories.userFactory;
  UserSettings? _userSettings;

  UserSettings? get userSettings=> _userSettings;

  void setUserTheme(BuildContext context){
    userFactory.getUserSettings().then((result){
      if(result.success){
        UserSettings settings = result.value!;
        _userSettings=settings;
        if(settings.themeMode==ThemeMode.dark){
          EasyDynamicTheme.of(context).changeTheme(dark: true);
        }else{
          EasyDynamicTheme.of(context).changeTheme(dark: false);
        }
      }else{
        Helper.showSnackBar(context, result.userMessage!,error: true);
      }
    });
  }

  void saveUserSettings(BuildContext context,UserSettings settings)async{
    userFactory.saveUserSettings(settings).then((result){
      if(result.success){
        UserSettings settings = result.value!;
        _userSettings=settings;
      }else{
        Helper.showSnackBar(context, result.userMessage!,error: true);
      }
    });
  }

  Future<Version> getPackageName()async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    return Version(version,buildNumber);
  }
}