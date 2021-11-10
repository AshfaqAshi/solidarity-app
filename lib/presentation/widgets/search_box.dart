import 'package:flutter/material.dart';
import 'package:solidarity_app/presentation/widgets/custom_form_field.dart';

class SearchBox extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onChange;
  SearchBox({required this.searchController,required this.onChange });

  @override
  Widget build(BuildContext context) {
    return CustomFormField(
      txtController: searchController,
      prefixIcon: Icons.search,
      onChange: (text){
        onChange(text!);
      },
      labelText: 'Search',
    );
  }
}
