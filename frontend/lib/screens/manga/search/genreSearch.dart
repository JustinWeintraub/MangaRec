import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/shared/genres.dart';
import 'package:frontend/shared/listWrapper.dart';
import 'package:frontend/widgets/customChip.dart';

class GenreSearch extends StatefulWidget {
  Function _onSubmit;
  Map<String, bool> _genreStates;

  GenreSearch(origGenreStates, onSubmit) {
    _genreStates = origGenreStates;
    _onSubmit = onSubmit;
  }
  @override
  _GenreSearchState createState() => _GenreSearchState(_genreStates, _onSubmit);
}

class _GenreSearchState extends State<GenreSearch> {
  Function _onSubmit;
  Map<String, bool> _genreStates; // whether or not genres are selected
  List<CustomChip> chips; // children
  bool _allState = false; // whether or not all genres are selected

  _GenreSearchState(origGenreStates, onSubmit) {
    _genreStates = origGenreStates;
    _onSubmit = onSubmit;
    chips = listWrapper(genreNames, createChild, onGenreChange, _genreStates)
        .cast<CustomChip>();
  }
  CustomChip createChild(name, onClick, selected) {
    //TODO add onClick
    return CustomChip(name, onClick, selected);
  }

  void changeAll(name, value) {
    _genreStates.forEach((k, v) => {_genreStates[k] = value});
    chips.forEach((chip) {
      chip.updateState(value);
    });
    if (mounted)
      setState(() {
        _allState = value;
        _genreStates = _genreStates;
      });
  }

  void onGenreChange(name, value) {
    _genreStates[name] = value;
  }

  void submit() {
    _onSubmit(_genreStates);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 100.0),
        child: Column(
            // TODO implement wrap
            children: [
              Container(
                alignment: Alignment.centerRight,
                child: CloseButton(
                  onPressed: submit,
                ),
              ),
              CustomChip("Select All", changeAll, _allState), // TODO
              Wrap(alignment: WrapAlignment.center, children: chips)
            ]));
  }
}
