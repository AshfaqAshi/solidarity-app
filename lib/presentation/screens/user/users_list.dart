import 'package:flutter/material.dart';
import 'package:solidarity_app/application/user/user_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solidarity_app/domain/user/user.dart';
import 'package:solidarity_app/presentation/core/helper.dart';
import 'package:solidarity_app/presentation/core/scaffold_base.dart';
import 'package:solidarity_app/presentation/widgets/all_widgets.dart';


class UserListArguments{
  List<String>? selectedUidList;
  UserListArguments({this.selectedUidList});
}
class UsersList extends ScaffoldBase {
  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends ScaffoldBaseState<UsersList> {

 late  UserBloc userBloc;
  UserListArguments? args;

 TextEditingController txtSearch = TextEditingController();

 String title()=>'Members';

 bool needScrollView()=>false;
  void initState(){
    super.initState();
    userBloc = context.read<UserBloc>();
    userBloc.add(GetAllUsersEvent());
  }

  bool _isTileEnabled(User user){
    //if [user.uid] is contained in [widget.selectedUidList],return false
    if(args!=null && args!.selectedUidList!=null){
      if(args!.selectedUidList!.contains(user.uid)){
        return false;
      }
      return true;
    }
    return true;
  }



  @override
  Widget body() {
    if(args==null){
      if(ModalRoute.of(context)!.settings.arguments!=null){
        args = ModalRoute.of(context)!.settings.arguments as UserListArguments;
      }
    }
    return  BlocConsumer<UserBloc,UserState>(
        builder: (context, state){

         if(state is GetAllUsersState){
           return LoadingWidget();
         }

         if(state is GetAllUsersCompleteState){
           if(state.result.success){
             List<User> _users = state.result.value!;
             if(_users.length==1){
               if(_users[0].uid==userBloc.loggedInUser!.uid){
                 //This means currently loggedInUser is the only user
                 //signed up into the app.
                 return Center(
                   child: Text('No users found!'),
                 );
               }

             }
             return Column(
               children: [
                 SearchBox(searchController: txtSearch,
                 onChange: (text){
                   setState(() {

                   });
                 },),
                 Expanded(
                   child: ListView(
                       children: _users.map((user){
                         if(user.name!.toLowerCase().contains(txtSearch.text.toLowerCase())
                         && user.uid!=userBloc.loggedInUser!.uid){
                           return UserBox(
                             user,
                             enabled: _isTileEnabled(user),
                             onPress: (){
                               Navigator.pop(context,user);
                             },
                           );
                         }
                         return Container();
                       }).toList()
                   ),
                 )
               ],
             );
           }else{
             return Center(child: Text('Sorry, an error occurred',style: Theme.of(context).textTheme.bodyText1!
               .copyWith(color: Theme.of(context).colorScheme.error),),);
           }
         }

         return Container();
        },
        listener: (context,state){
          if(state is GetAllUsersCompleteState){
            if(!state.result.success){
              Helper.showSnackBar(context, state.result.userMessage!,error: true);
            }
          }
        },
      );
  }
}
