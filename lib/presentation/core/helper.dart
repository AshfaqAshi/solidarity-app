
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:solidarity_app/domain/report/field.dart';
import 'package:solidarity_app/domain/report/report.dart';
import 'package:solidarity_app/domain/user/user.dart';
import 'package:solidarity_app/presentation/core/screens.dart';
import 'package:solidarity_app/presentation/screens/area/add_area_report.dart';
import 'package:solidarity_app/presentation/screens/area/add_area_screen.dart';
import 'package:solidarity_app/presentation/screens/area/area_details_screen.dart';
import 'package:solidarity_app/presentation/screens/area/area_list.dart';
import 'package:solidarity_app/presentation/screens/area/area_report_details.dart';
import 'package:solidarity_app/presentation/screens/area_unit_selector_screen.dart';
import 'package:solidarity_app/presentation/screens/home_screen.dart';
import 'package:solidarity_app/presentation/screens/loading_screen.dart';
import 'package:solidarity_app/presentation/screens/login_screen.dart';
import 'package:solidarity_app/presentation/screens/unit/add_unit_report.dart';
import 'package:solidarity_app/presentation/screens/unit/add_unit_screen.dart';
import 'package:solidarity_app/presentation/screens/unit/unit_details_screen.dart';
import 'package:solidarity_app/presentation/screens/unit/unit_report_details.dart';
import 'package:solidarity_app/presentation/screens/user/user_details_screen.dart';
import 'package:solidarity_app/presentation/screens/user/user_profile.dart';
import 'package:solidarity_app/presentation/screens/user/users_list.dart';
import 'package:intl/intl.dart';
import 'package:solidarity_app/presentation/dialogs/confirmation_dialog.dart';

class Helper{

  static Map<String, Widget Function(BuildContext context)> namedRoutes={
    Screens.HOME: (_)=>HomeScreen(),
    Screens.LOADING: (_)=>LoadingScreen(),
    Screens.LOGIN:(_)=>LoginScreen(),
    Screens.ADD_AREA: (_)=>AddAreaScreen(),
    Screens.USER_LIST:(_)=>UsersList(),
    Screens.USER_DETAILS:(_)=>UserDetailsScreen(),
    Screens.USER_PROFILE:(_)=>UserProfile(),
    Screens.AREA_LIST:(_)=>AreaList(),
    Screens.AREA_DETAILS:(_)=>AreaDetailsScreen(),
    Screens.AREA_REPORT_DETAILS:(_)=>AreaReportDetails(),
    Screens.ADD_AREA_REPORT:(_)=>AddAreaReportScreen(),
    Screens.ADD_UNIT:(_)=>AddUnitScreen(),
    Screens.UNIT_DETAILS:(_)=>UnitDetailsScreen(),
    Screens.ADD_UNIT_REPORT: (_)=>AddUnitReportScreen(),
    Screens.UNIT_REPORT_DETAILS:(_)=>UnitReportDetails(),
    Screens.AREA_UNIT_SELECTOR: (_)=>AreaUnitSelectorScreen()
  };

  static List<String> roleHierarchyList=[
    UserDesignation.UNIT_MEMBER,
    UserDesignation.UNIT_JOINT_SECRETARY,
    UserDesignation.UNIT_SECRETARY,
    UserDesignation.UNIT_PRESIDENT,
    UserDesignation.AREA_MEMBER,
    UserDesignation.AREA_JOINT_SECRETARY,
    UserDesignation.AREA_SECRETARY,
    UserDesignation.AREA_PRESIDENT,
    UserDesignation.ADMIN
  ];

  static void navigate(BuildContext context,String name,{bool pushReplace=false, Object? arguments}){
    if(pushReplace){
      Navigator.of(context).pushReplacementNamed(name);
    }else{
      Navigator.of(context).pushNamed(name, arguments: arguments);
    }

  }

  static bool hasPrivilege(String designation, String field){
   if(field==UserField.AREA){
     if(designation==UserDesignation.ADMIN || designation==UserDesignation.AREA_PRESIDENT ||
         designation==UserDesignation.AREA_JOINT_SECRETARY|| designation==UserDesignation.AREA_SECRETARY){
       return true;
     }
   }else{
     if(designation==UserDesignation.ADMIN || designation==UserDesignation.UNIT_PRESIDENT ||
         designation==UserDesignation.UNIT_JOINT_SECRETARY|| designation==UserDesignation.UNIT_SECRETARY){
       return true;
     }
   }
    return false;
  }

  static String getReportContentAsString(bool hasError, bool isLoading, Report? report,{int max=200}){
    if(hasError){
      return 'An error occurred';
    }else if(isLoading){
      return 'Getting last report';
    }else if(report==null){
      return 'No report found for last month';
    }else{
      String text='Report for ${report.monthName}:';
      String? trimmedText;
      if(report.fields==null){
        text='Empty report';
      }else{
        report.fields!.forEach((field){
          if(field.type==FieldTypes.TEXT || field.type==FieldTypes.TEXT_AREA){
            text+='${field.name}: ${field.value}\n';
          }

        });
      }
      if(text.length>max){
        trimmedText = '${text.substring(0,max)}...';
      }else{
        trimmedText=text;
      }
      return trimmedText;
    }
  }

  static void removeTextBoxFocus(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  static void showSnackBar(BuildContext context, String text,{String? actionText, VoidCallback? onAction,
  bool error=false}){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: error?Color(0xff9E1515):null,
      content: Text(text,style: error?Theme.of(context).textTheme.bodyText2
        !.copyWith(color: Colors.white):null,),
      action: actionText!=null?SnackBarAction(label: actionText, onPressed: onAction! ):null,
    ));
  }

  static Future<bool> getConfirmation(BuildContext context,ConfirmationDialog dialog)async{
    var result = await showDialog(context: context, builder: (_)=>dialog);
    if(result!=null && result){
      return true;
    }
    return false;
  }

  static String getMonthNameFromCode(int code){
    Map<int,String> monthList={
      1: 'January',
      2:'February',
      3: 'March',
      4: 'April',
      5: 'May',
      6: 'June',
      7: 'July',
      8: 'August',
      9: 'September',
      10: 'October',
      11: 'November',
      12: 'December'
    };

    return monthList[code]!;
  }

  static String getDateString(
      DateTime? date, {
        bool rawFormat = false,
        bool monthAndYearOnly=false
      }) {
    ///Date format used is MM/DD/YYYY
    if (date == null) {
      return 'Failed to format date';
    } else {
      DateFormat df;

      if (!rawFormat) {
        if(monthAndYearOnly){
          df = DateFormat('yMMM');
        }else{
          df = DateFormat('yMMMMd');
        }

      } else
        df = DateFormat('yMd');

      return df.format(date).toString();
    }
  }

  static String getUserDesignation(String? designation){
    if(designation==UserDesignation.ADMIN){
      return 'Admin';
    }else if(designation==UserDesignation.UNIT_PRESIDENT){
      return 'Unit President';
    }if(designation==UserDesignation.UNIT_SECRETARY){
      return 'Unit Secretary';
    }if(designation==UserDesignation.UNIT_JOINT_SECRETARY){
      return 'Unit Joint Secretary';
    }if(designation==UserDesignation.UNIT_MEMBER){
      return 'Unit Member';
    }
    if(designation==UserDesignation.AREA_PRESIDENT){
      return 'Area President';
    }if(designation==UserDesignation.AREA_SECRETARY){
      return 'Area Secretary';
    }if(designation==UserDesignation.AREA_JOINT_SECRETARY){
      return 'Area Joint Secretary';
    }if(designation==UserDesignation.AREA_MEMBER){
      return 'Area Member';
    }
    return 'Member';
  }

  static String getUserFieldFromDesignation(String designation){
    List areaDesigs=[
      UserDesignation.AREA_JOINT_SECRETARY,
      UserDesignation.AREA_PRESIDENT,
      UserDesignation.AREA_SECRETARY
    ];

    List unitDesigs=[
      UserDesignation.UNIT_JOINT_SECRETARY,
      UserDesignation.UNIT_PRESIDENT,
      UserDesignation.UNIT_SECRETARY
    ];

    if(areaDesigs.contains(designation)){
      return UserField.AREA;
    }else{
      return UserField.UNIT;
    }
  }

}