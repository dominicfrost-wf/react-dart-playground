import 'dart:html';
import 'dart:math' show Random;
import 'package:react/react_client.dart' as reactClient;
import 'package:react/react.dart';

void main() {
  reactClient.setClientConfiguration();
  var app = registerComponent(() => new App());
  render(app({}), querySelector('#content'));
}


class App extends Component {
  
  var widgets = registerComponent(() => new Widgets());
  var badge = registerComponent(() => new Badge());
  
  getInitialState() {
    return {
      'name': '',
      'disabled': false,
      'text': 'Aye! Gimme a name'
    };
  }
  
  render() { 
    return div({}, [
      h1({}, "Pirate Badge"),
      div({}, widgets({'generateBadge': generateBadge, 'updateBadge': updateBadge, 'disabled': state['disabled'], 'text': state['text']})),
      div({}, badge({"name": state['name']}))
    ]);
  }
  
  generateBadge(SyntheticMouseEvent e) {
    setState({
      'name': new PirateName().pirateName       
    });
  }
  
  updateBadge(SyntheticFormEvent e) {
    String inputName = (e.target as InputElement).value;
    bool disabled;
    String text;
    if (inputName.trim().isEmpty) {
      disabled = false;
      text = 'Aye! Gimme a name';
    } else {
      disabled = true;
      text = 'Arr! Write yer name';
    }
    setState({
      'disabled': disabled,
      'text': text,
      'name': new PirateName(firstName: inputName).pirateName
    }); 
  }
}

class Widgets extends Component {
  render() {
    return div({"className": "widgets"}, [
      div({}, input({"onChange":props['updateBadge'], "type":"text", "id":"inputName", "maxLength":"15"})),
      div({}, button({"onClick": props['generateBadge'], 'disabled': props['disabled']}, props['text']))
    ]);
  }
}

class Badge extends Component {
  render() {
    return div({"className": "badge"}, [
      div({"className": "greeting"}, "Arrr! Me Name is"),
      div({"className": "name"}, span({"id":"badgeName"}, props['name']))
    ]);
  }
}

class PirateName {
  static final Random indexGen = new Random();
  String _firstName, _appellation;
  
  PirateName({String firstName, String appellation}) {
    if (firstName == null) {
      _firstName = names[indexGen.nextInt(names.length)];
    } else {
      _firstName = firstName;
    }
    
    if (appellation == null) {
      _appellation = appellations[indexGen.nextInt(appellations.length)];
    } else {
      _firstName = firstName;
    }
  }

  String get pirateName =>
      _firstName.isEmpty ? '' : '$_firstName the $_appellation';
  
  String toString() => pirateName;
  
  static final List names = [
      'Anne', 'Mary', 'Jack', 'Morgan', 'Roger',
      'Bill', 'Ragnar', 'Ed', 'John', 'Jane' ];
  
  static final List appellations = [
    'Jackal', 'King', 'Red', 'Stalwart', 'Axe',
    'Young', 'Brave', 'Eager', 'Wily', 'Zesty'];
}