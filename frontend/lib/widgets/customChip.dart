import 'package:flutter/material.dart';

// a chip is a ui object that can selected

class CustomChip extends StatefulWidget {
  //final Function toggleView;
  //Wrapper({this.toggleView});
  //TODO implement state
  String _name;
  Function _onClick;
  bool _isSelected;

  CustomChip(data, onClick, isSelected) {
    _name = data;
    _onClick = onClick;
    _isSelected = isSelected;
  }

  final _CustomChipState state = _CustomChipState();

  @override
  _CustomChipState createState() => state;

  updateState(bool selected) {
    state.updateState(selected);
    //_CustomChipState createState() => _CustomChipState(_name, _onClick, state);
  }
}

//TODO https://stackoverflow.com/questions/54759920/flutter-why-is-child-widgets-initstate-is-not-called-on-every-rebuild-of-pa
class _CustomChipState extends State<CustomChip> {
  @override
  void didUpdateWidget(oldWidget) {
    /*super.didUpdateWidget(oldWidget);
    if (_name != "Select All") {
      setState(() {
        _isSelected = !oldWidget._isSelected;
      });
    }
*/
    //if (oldWidget.searchTerm != widget.searchTerm) {

    // this.updateChildWithParent();

    //}
  }
  void updateState(selected) {
    setState(() {
      widget._isSelected = selected;
    });
    widget._isSelected = selected;
  }

  @override
  Widget build(BuildContext context) {
    String _name = widget._name;
    Function _onClick = widget._onClick;
    bool _isSelected = widget._isSelected;
    return FilterChip(
      labelStyle: TextStyle(color: _isSelected ? Colors.black : Colors.grey),
      onSelected: (bool selected) {
        setState(() {
          widget._isSelected = !widget._isSelected;
        });
        if (_onClick != null) _onClick(_name, widget._isSelected);
      },
      backgroundColor: Colors.white12,
      //selectedColor: Theme.of(context).accentColor,
      //checkmarkColor: Colors.black,
      label: Text(_name),
    );
  }
}
