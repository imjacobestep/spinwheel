import 'package:flutter/material.dart';
import 'package:spin_wheel/database.dart';
import 'package:spin_wheel/models.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'home.dart';

class EditPage extends StatefulWidget{

  @override
  EditPageState createState() => EditPageState();
  List<Option> options = [];
  OptionList oL;

  EditPage({this.oL});

}

class EditPageState extends State<EditPage>{

  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController;
  static List<String> optionsList = [''];

  List<Widget> _getOptions(){
    List<Widget> optionsTextFieldsList = [];
    for(int i=0; i<optionsList.length; i++){
      optionsTextFieldsList.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              Expanded(child: OptionTextsFields(i),),
              SizedBox(width: 16,),
              _addRemoveButton(i == 0, i),
            ],
          ),
        )
      );
    } return optionsTextFieldsList;
  }

  void saveList() async {
    widget.oL.clearList();
    for(int i = 0; i < optionsList.length; i++){
      widget.oL.addOption(optionsList[i]);
    }
    widget.oL.updateName(_nameController.text);
    if(listExists(widget.oL)){
      await DBProvider.db.updateList(widget.oL);
    }else{
      await DBProvider.db.newList(widget.oL);
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    print("BACK BUTTON!"); // Do some stuff.
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
    return true;
  }

  Future<void> _showMyDialog() async{
    return showDialog<void>(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Lists have a max of 16 options', style: Theme.of(context).textTheme.bodyText1,),
            backgroundColor: Theme.of(context).cardColor,
            actions: <Widget>[
              TextButton(
                child: Text('ok', style: Theme.of(context).textTheme.subtitle1,),
                onPressed: (){
                  Navigator.of(context).pop('true');
                },
              ),
            ],
          );
        }
    );
  }

  Widget _addRemoveButton(bool add, int index){
    return InkWell(
      onTap: (){
        if(index >= 16){
          _showMyDialog();
        }
        else if(add){
          optionsList.insert(0, null);
        }
        else optionsList.removeAt(index);
        setState(() {});
      },
      child: Container(
        width: 30, height: 30,
        decoration: BoxDecoration(
          color: (add) ? Theme.of(context).colorScheme.primary  :  Theme.of(context).colorScheme.error,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
            (add) ? Icons.add : Icons.remove,color: Theme.of(context).backgroundColor,
        ),
      ),
    );
  }

  @override
  void initState(){
    BackButtonInterceptor.add(myInterceptor);
    super.initState();
    widget.options = widget.oL.options;
    if(widget.options.isNotEmpty){
      optionsList.clear();
    for(int i = 0; i < widget.options.length; i++){
      optionsList.add(widget.oL.options[i].optionText);
    }}
    _nameController = TextEditingController();
    _nameController.text = widget.oL.listName;
  }

  @override
  void dispose(){
    BackButtonInterceptor.remove(myInterceptor);
    _nameController.dispose();
    optionsList.clear();
    optionsList.add('');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).canvasColor,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('List Name', style: Theme.of(context).textTheme.headlineSmall,),
                    SizedBox(height: 16,),
                    TextFormField(
                      style: Theme.of(context).textTheme.bodyMedium,
                      controller: _nameController,
                      decoration: InputDecoration(
                          labelStyle: Theme.of(context).textTheme.labelLarge,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.outline, width: 3)
                          ),
                          labelText: 'give your list a recognizable name',
                          errorStyle: TextStyle(color: Theme.of(context).errorColor)
                      ),
                      validator: (v){
                        if(v.trim().isEmpty){
                          return 'Please enter something';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16,),
                    Text('Options', style: Theme.of(context).textTheme.headlineSmall,),
                    ..._getOptions(),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
              icon: Icon(Icons.check, color: Theme.of(context).colorScheme.onPrimary),
              label: Text("Done",
                style: TextStyle(
                    fontSize: Theme.of(context).textTheme.titleMedium.fontSize,
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: Theme.of(context).textTheme.titleMedium.fontWeight),
              ),
              onPressed: (){
                if(_formKey.currentState.validate()){saveList();}
              },
              backgroundColor: Theme.of(context).colorScheme.primary
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          backgroundColor: Color.alphaBlend(Theme.of(context).colorScheme.surfaceVariant.withAlpha(200), Theme.of(context).colorScheme.surface),
        ),
      ),
    );
  }
}

class OptionTextsFields extends StatefulWidget {

  final int index;
  OptionTextsFields(this.index);

  @override
  OptionTextsFieldsState createState() => OptionTextsFieldsState();
}

class OptionTextsFieldsState extends State<OptionTextsFields>{

  TextEditingController _nameController;

  @override
  void initState(){
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose(){
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _nameController.text = EditPageState.optionsList[widget.index]
          ?? '';
    });

    return TextFormField(
      controller: _nameController,
      style: Theme.of(context).textTheme.bodyMedium,
      onChanged: (v) => EditPageState.optionsList[widget.index] = v,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).colorScheme.outline, width: 3)
          ),
          labelStyle: Theme.of(context).textTheme.labelLarge,
          labelText: 'enter an option'
      ),
      validator: (v){
        if(v.trim().isEmpty) return 'please enter something';
        return null;
      },
    );

  }

}