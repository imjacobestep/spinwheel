import 'dart:async';
import 'package:flutter/material.dart';
import 'package:spin_wheel/database.dart';
import 'package:spin_wheel/pages/spin_page.dart';
import '../models.dart';
import 'edit_page.dart';
import 'package:dynamic_color/dynamic_color.dart';

class Home extends StatefulWidget{

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home>{

  List<OptionList> optionListList = listList;

  @override
  void initState(){
    super.initState();
  }

  Widget getListList(BuildContext context){
    if(optionListList.isEmpty){
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Column(
                  children: [
                    Text(
                      "You don't have any lists",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      "Press '+' to create a new list",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                )
            ),
          ]
      );
    }
    return ListView.builder(
        itemCount: optionListList.length,
        itemBuilder: (BuildContext context, int index){
          return Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40.0))),
                color: Theme.of(context).colorScheme.primaryContainer,
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  splashColor: Theme.of(context).colorScheme.primary,
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SpinPage(optionList: optionListList[index],)));
                  },
                  onLongPress: (){
                    _showMyDialog(index);
                  },
                  child: Container(
                    child: Text(optionListList[index].listName, style: Theme.of(context).textTheme.headlineSmall,),
                    padding: EdgeInsets.all(20),
                  ),
                ),
              )
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Lists', style: Theme.of(context).textTheme.headlineSmall,),
            Spacer(),
            Text(' long press to edit or delete', style: Theme.of(context).textTheme.bodyMedium,),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: getListList(context),
      ),
      floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.add_outlined, color: Theme.of(context).colorScheme.onPrimary,),
          label: Text("New List", style: TextStyle(
              fontSize: Theme.of(context).textTheme.titleMedium.fontSize,
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: Theme.of(context).textTheme.titleMedium.fontWeight),
          ),
          onPressed: (){
            OptionList temp =  OptionList(listName: '', listID: randomInt());
            List<Option> tempList = [];
            temp.setOptions(tempList);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EditPage(oL: temp)));
          },
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.primary
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Color.alphaBlend(Theme.of(context).colorScheme.surfaceVariant.withAlpha(200), Theme.of(context).colorScheme.surface),
    );
  }

  Future<void> toEdit(OptionList oL) async {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EditPage(oL: oL)));
    Route route = MaterialPageRoute(builder: (context) => EditPage(oL: oL));
    await Navigator.pushReplacement(context, route).then((value) => onGoBack(value));
  }

  FutureOr onGoBack(dynamic value){
    if(value){
      setState(() {optionListList = listList;});
    }
  }

  Future<void> _showMyDialog(int index) async{
    return showDialog<void>(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Do you want to edit or delete this list?', style: Theme.of(context).textTheme.headlineSmall,),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40.0))),
            titlePadding: EdgeInsets.all(40),
            actionsPadding: EdgeInsets.all(16),
            actions: <Widget>[
              TextButton(
                child: Text('Delete', style: TextStyle(
                    fontSize: Theme.of(context).textTheme.displayMedium.fontSize,
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: Theme.of(context).textTheme.displayMedium.fontWeight),),
                onPressed: (){
                  DBProvider.db.deleteList(optionListList[index]);
                  optionListList.remove(index);
                  setState(() {});
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text('Edit', style: Theme.of(context).textTheme.displayMedium,),
                onPressed: () async {
                  setState(() {});
                  Navigator.pop(context);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EditPage(oL: optionListList[index])));
                },
              ),
              TextButton(
                child: Text('Cancel', style: Theme.of(context).textTheme.displayMedium,),
                onPressed: (){
                  setState(() {});
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }

}