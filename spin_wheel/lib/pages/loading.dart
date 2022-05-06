import 'package:flutter/material.dart';
import 'package:spin_wheel/database.dart' as Store;
import 'home.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
          color: Theme.of(context).canvasColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Loading",
                style: Theme.of(context).textTheme.headline1,
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
                valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
              ),
            ],
          ),
        )
    );
  }
}

class InitLoad extends StatefulWidget{

  @override
  InitLoadState createState() => InitLoadState();

}

class InitLoadState extends State<InitLoad> {

  @override
  void initState() {
    super.initState();
    Store.initStore().whenComplete(() => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Home()
        )
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
          color: Theme.of(context).canvasColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Loading",
                style: Theme.of(context).textTheme.headline1,
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
                valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
              ),
            ],
          ),
        )
    );
  }

}


