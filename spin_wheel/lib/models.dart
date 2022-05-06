class OptionList{

  String listName;
  int listID;
  List<Option> options = [];

  OptionList({this.listName, this.listID});

  OptionList.fromMap(Map<String, dynamic> map){
    listName = map['listName'];
    listID = map['listID'];
  }

  void updateList(String n, List<Option> l){
    listName = n;
    options = l;
  }

  void clearList(){
    options.clear();
  }

  void updateName(String s){
    listName = s;
  }

  void addOption(String s){
    Option o = new Option(optionText: s, listID: this.listID);
    options.add(o);
  }

  void setOptions(List<Option> o){
    options = o;
  }

}

class Option{
  String optionText;
  int listID;

  Option({this.optionText, this.listID});

  Option.fromMap(Map<String, dynamic> map){
    optionText = map['optionText'];
    listID = map['listID'];
  }

}