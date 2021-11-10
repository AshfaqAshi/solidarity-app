import 'package:flutter/material.dart';
import 'package:solidarity_app/presentation/core/constants.dart';

class CustomFormField extends StatelessWidget{
  TextEditingController? txtController;
  String? helperText;
  String? labelText;
  String? hintText;
  IconData? prefixIcon;
  bool? multiline;
  bool number;
  Function(String?)? onValidate;
  Function(String?)? onChange;

  CustomFormField({this.txtController, this.onValidate,this.onChange,this.hintText,this.helperText,this.labelText,this.prefixIcon,
  this.multiline=false,this.number=false});
  Widget build(BuildContext context){
    return TextFormField(
      controller: txtController,
      onChanged: onChange!=null?onChange:null,
      validator: (value)=>onValidate!(value),
      maxLines: multiline!?null:1,
      keyboardType: number?TextInputType.phone:null,
      decoration: InputDecoration(
        labelText: labelText,
        fillColor: Theme.of(context).scaffoldBackgroundColor,
        filled: true,
        hintText: hintText,
        prefixIcon: prefixIcon!=null?Icon(prefixIcon):null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(Constants.TEXT_FIELD_BORDER_RADIUS),borderSide: BorderSide(
          width: 1
        )),
        contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 10)
      ),
    );
  }
}