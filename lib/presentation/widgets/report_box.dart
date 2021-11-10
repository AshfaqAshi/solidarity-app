import 'package:flutter/material.dart';
import 'package:solidarity_app/domain/report/report.dart';
import 'package:solidarity_app/presentation/core/constants.dart';
import 'package:solidarity_app/presentation/core/helper.dart';
class ReportBox extends StatelessWidget {
  final Report report;
  final VoidCallback onTap;
   ReportBox(this.report,{required this.onTap});

   Color _getColor(BuildContext context){
     if(this.report.type==ReportType.UNIT){
       return Theme.of(context).colorScheme.secondary;
     }
     return Theme.of(context).colorScheme.primary;
   }

   TextStyle _getTextStyle(BuildContext context){
     if(this.report.type==ReportType.UNIT){
       return Theme.of(context).textTheme.bodyText1!.copyWith(color: Theme.of(context).colorScheme.onSecondary);
     }
     return Theme.of(context).textTheme.bodyText1!.copyWith(color: Theme.of(context).colorScheme.onPrimary);
   }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom:Constants.REPORT_BOX_HEADER_PADDING),
      child: ElevatedButtonTheme(
        data: ElevatedButtonThemeData(
            style: ButtonStyle(
                alignment: Alignment.topLeft,
                backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.background),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Constants.BOX_BORDER_RADIUS)
                    )
                )
            )
        ),
        child: ElevatedButton(
          onPressed: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(Constants.LIST_TILE_TITLE_PADDING),
                decoration: BoxDecoration(
                    color: _getColor(context),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Constants.BOX_BORDER_RADIUS),
                      topRight: Radius.circular(Constants.BOX_BORDER_RADIUS)
                    )
                ),
                child: Text('${this.report.monthName}',style: _getTextStyle(context),),
              ),

              Padding(
                padding: EdgeInsets.all(Constants.LIST_TILE_CONTENT_PADDING),
                child: Text(Helper.getReportContentAsString(false, false, report),style: Theme.of(context).textTheme.bodyText2,),
              )
            ],
          ),
        ),
      ),
    );
  }
}
