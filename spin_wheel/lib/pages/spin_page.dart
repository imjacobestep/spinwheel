import 'dart:async';
import 'dart:math';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:spin_wheel/models.dart';

class SpinPage extends StatefulWidget{

  @override
  SpinPageState createState() => SpinPageState();

  OptionList optionList;
  SpinPage({this.optionList});

}

class SpinPageState extends State<SpinPage>{
  //List<String> strings = ['thing1', 'thing2', 'thing3', 'thing4'];
  String selectedItem = '';
  int selected = 0;
  @override
  void initState(){
    super.initState();
  }

  List<FortuneItem> getWheelItems(){
    List<FortuneItem> ret = [];
    List<Color> colors = [Theme.of(context).colorScheme.primaryContainer, Theme.of(context).colorScheme.secondaryContainer, Theme.of(context).colorScheme.primaryContainer, Theme.of(context).colorScheme.secondaryContainer];
    for(int i = 0; i < widget.optionList.options.length; i++){
      ret.add(FortuneItem(
          child: Text(widget.optionList.options[i].optionText, style: Theme.of(context).textTheme.labelLarge,),
          style: FortuneItemStyle(
            borderWidth: 0,
            color: colors[i%4],
          )
      ));
    }
    return ret;
  }

  FortuneIndicator getSpin(){
    return FortuneIndicator(
        child: Container(
          height: 60,
          width: 60,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: (){
                setState(() {
                  selected = Random().nextInt(widget.optionList.options.length);
                });
              },
              elevation: 0,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text('spin',
                style: TextStyle(
                    fontSize: Theme.of(context).textTheme.titleMedium.fontSize,
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: Theme.of(context).textTheme.titleMedium.fontWeight),
              ),
            ),
          ),
        )
    );
  }

  Future<void> _showMyDialog() async{
    selectedItem = widget.optionList.options[selected].optionText;
    return showDialog<void>(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            content: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset('assets/selection.png', width: 400, fit: BoxFit.cover,),
                Text('selected: ' + selectedItem, style: Theme.of(context).textTheme.headlineSmall,),
              ],
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40.0))),
            titlePadding: EdgeInsets.all(40),
            actionsPadding: EdgeInsets.all(16),
            actions: <Widget>[
              TextButton(
                child: Text('ok', style: Theme.of(context).textTheme.displayMedium,),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
    );
  }

  FortuneIndicator getIndicator(){
    return FortuneIndicator(
      alignment: Alignment.topCenter,
        child: Triangle.isosceles(
          edge: Edge.BOTTOM,
          child: GestureDetector(
            child: Container(
              color: Color.alphaBlend(Theme.of(context).colorScheme.surfaceVariant.withAlpha(160), Theme.of(context).colorScheme.surface),
              width: 25.0,
              height: 25.0,
              child: Center(child: Text('')),
            ),
          ),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    selected = Random().nextInt(widget.optionList.options.length);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.optionList.listName, style: Theme.of(context).textTheme.headlineSmall,),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onSurface),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: GestureDetector(
          onTap: (){
            setState(() {
              selected = Random().nextInt(widget.optionList.options.length);
            });
          },
          child: FortuneWheel(
            physics: CircularPanPhysics(
              duration: Duration(seconds: 1),
              curve: Curves.decelerate,
            ),
            onFling: () {
              selected = Random().nextInt(widget.optionList.options.length);
            },
            selected: Stream.value(selected),
            items: getWheelItems(),
            styleStrategy: AlternatingStyleStrategy(),
            indicators: [getSpin(), getIndicator()],
            onAnimationEnd: _showMyDialog,
          ),
        ),
      ),
      backgroundColor: Color.alphaBlend(Theme.of(context).colorScheme.surfaceVariant.withAlpha(160), Theme.of(context).colorScheme.surface),
    );
  }
}