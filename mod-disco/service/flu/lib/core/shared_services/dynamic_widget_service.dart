import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:mod_disco/core/i18n/mod_disco_localization.dart';

typedef void StandardCallbackInjection(String selected);
typedef void DropdownCallbackInjection(Map<String, String> data,
    String selected);

class DynamicWidgetService {
  Map<String, String> selectedDropdownOptions = {};
}

class DynamicWidgetMapService {
  Map<String, Map<String, String>> selectedDropdownOptions = {};
}

class DynamicMaterialPicker extends StatefulWidget {
  final String _title;
  final String _selected;
  final Map<String, String> _data;
  final DropdownCallbackInjection _callbackInjection;

  DynamicMaterialPicker({@required Map<String, String> data,
    @required String selectedOption,
    @required String title,
    @required DropdownCallbackInjection callbackInjection})
      : this._data = data,
        this._title = title,
        this._selected = selectedOption,
        this._callbackInjection = callbackInjection;

  @override
  _DynamicMaterialPickerState createState() => _DynamicMaterialPickerState();
}

class _DynamicMaterialPickerState extends State<DynamicMaterialPicker> {
  List<String> choices = [];

  Map<String, String> get datas => widget._data;

  String get selected => widget._selected;
  String chosen;

  @override
  void initState() {
    choices.addAll(datas.keys.toList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 25, 0),
      child: InkWell(
        child: Text(
          widget._selected == null
              ? ModDiscoLocalizations.of(context).translate('pleaseClickToSelectAvailableOptions')
              : selected,
          style: Theme
              .of(context)
              .textTheme
              .subtitle1,
        ),
        onTap: () =>
            showMaterialScrollPicker(
              context: context,
              title: widget._title,
              showDivider: false,
              items: choices,
              selectedItem: selected,
              onChanged: (val) {
                widget._callbackInjection(widget._data, val);
              },
            ),
      ),
    );
  }
}

class DynamicDropdownButton extends StatelessWidget {
  final String _selected;
  final Map<String, String> _data;
  final DropdownCallbackInjection _callbackInjection;

  DynamicDropdownButton({Map<String, String> data,
    String selectedOption,
    DropdownCallbackInjection callbackInjection})
      : this._data = data,
        this._selected = selectedOption,
        this._callbackInjection = callbackInjection;

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> dropdownItems = this
        ._data
        .keys
        .map(
          (answer) =>
          DropdownMenuItem(
            key: Key(answer),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(answer),
            ),
            value: answer,
          ),
    )
        .toList();

    return Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 25, 0),
        child: DropdownButton(
          hint: Text(ModDiscoLocalizations.of(context).translate('pleaseSelectAnOptionFromTheList')),
          items: dropdownItems,
          icon: Icon(Icons.arrow_drop_down),
          iconSize: 24,
          isExpanded: true,
          value: this._selected,
          onChanged: (String value) {
            if (this._callbackInjection != null) {
              this._callbackInjection(this._data, value);
            }
          },
        ));
  }
}

class DynamicMultilineTextFormField extends StatefulWidget {
  final StandardCallbackInjection _callbackInjection;
  final String _question;

  DynamicMultilineTextFormField(
      {String question, StandardCallbackInjection callbackInjection})
      : this._question = question,
        this._callbackInjection = callbackInjection;

  @override
  _DynamicMultilineTextFormFieldState createState() =>
      _DynamicMultilineTextFormFieldState();
}

class _DynamicMultilineTextFormFieldState
    extends State<DynamicMultilineTextFormField> {
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            this.widget._question,
            style: Theme
                .of(context)
                .textTheme
                .subtitle1,
          ),
          TextFormField(
            initialValue: '',
            maxLines: 5,
            decoration: InputDecoration(
              alignLabelWithHint: true,
              hintText: ModDiscoLocalizations.of(context).translate('typeYourAnswerHere'),
              fillColor: Theme
                  .of(context)
                  .inputDecorationTheme
                  .fillColor,
              /*border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: const BorderSide(),
              ),*/
            ),
            onChanged: (String value) {
              if (this.widget._callbackInjection != null) {
                this.widget._callbackInjection(value);
              }
            },
            onSaved: (String value) {
              if (this.widget._callbackInjection != null) {
                this.widget._callbackInjection(value);
              }
            },
            keyboardType: TextInputType.multiline,
            style: const TextStyle(
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}

class DynamicSlider extends StatefulWidget {
  final StandardCallbackInjection _callbackInjection;
  final String _title, _question, _uom;
  final double _min, _max, _current;

  DynamicSlider({String title,
    String question,
    double current,
    double min,
    double max,
    String uom,
    StandardCallbackInjection callbackInjection})
      : this._question = question,
        this._title = title,
        this._current = current,
        this._min = min,
        this._max = max,
        this._uom = uom,
        this._callbackInjection = callbackInjection;

  @override
  _DynamicSliderState createState() => _DynamicSliderState();
}

class _DynamicSliderState extends State<DynamicSlider> {
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                title: Text(
                  this.widget._title,
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline6,
                ),
              ),
              ListTile(
                title: Text(
                  this.widget._question,
                  style: Theme
                      .of(context)
                      .textTheme
                      .subtitle1,
                ),
              ),
              const SizedBox(height: 8.0),
              ListTile(
                title: Text(
                  ModDiscoLocalizations.of(context).translate('minimumPledgedTime'),
                  style: Theme
                      .of(context)
                      .textTheme
                      .subtitle2,
                ),
                trailing: Text(
                  '${this.widget._current} ${ModDiscoLocalizations.of(context).translate('hours')}/${this.widget._uom}',
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                subtitle: Slider(
                    label: this.widget._current.toString(),
                    divisions: this.widget._max.toInt(),
                    min: this.widget._min,
                    max: this.widget._max,
                    value: this.widget._current,
                    onChanged: (double value) {
                      this.widget._callbackInjection(value.toString());
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
