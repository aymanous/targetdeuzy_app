import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:targetapp/custom/custom.dart';
import 'package:targetapp/fragments/header.dart';
import 'package:targetapp/models/http_service.dart';
import 'package:targetapp/models/indicator_model.dart';
import 'package:targetapp/models/space_model.dart';
import 'package:targetapp/plugins/date_picker/flutter_datetime_picker.dart';
import 'package:flutter/scheduler.dart';

final _formKey = GlobalKey<FormState>();
final HttpService httpService = HttpService();

class NewEntry extends StatelessWidget {
  final spaceId;
  const NewEntry({Key key, this.spaceId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(title: "Nouvelle saisie", showActions: false),
      backgroundColor: style["colors"]["white"],
      body: FutureBuilder(
          future: httpService.getSpace(this.spaceId),
          builder: (BuildContext context, AsyncSnapshot<Space> snapshot) {
            if (snapshot.hasData) {
              return NewEntryContent(space: snapshot.data);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

class NewEntryContent extends StatefulWidget {
  final Space space;
  NewEntryContent({Key key, this.space}) : super(key: key);

  @override
  _NewEntryContentState createState() => _NewEntryContentState();
}

dynamic entryDate;
dynamic indicatorsValues;

class _NewEntryContentState extends State<NewEntryContent> {
  @override
  void initState() {
    super.initState();
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance
          .addPostFrameCallback((_) => showDatePicker(context));
    }

    entryDate = DateTime.now();
    indicatorsValues = [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 15),
                child: Text(
                  widget.space.name,
                  style: TextStyle(
                      fontSize: style["h4"]["size"],
                      fontFamily: style["font"]["Medium"],
                      color: style["colors"]["black"]),
                  textAlign: TextAlign.center,
                ),
              ),
              ButtonTheme(
                minWidth: MediaQuery.of(context).size.width,
                child: OutlineButton(
                  padding: style["padding"]["button"],
                  color: style["colors"]["primary"],
                  shape: new RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(style["radius"]["button"])),
                  onPressed: () {
                    showDatePicker(context);
                  },
                  child: Text(dateFormatting(entryDate),
                      style: TextStyle(
                        color: style["colors"]["primary"],
                        fontSize: style["button"]["size"],
                        fontFamily: style["font"]["Bold"],
                      )),
                ),
              ),
            ],
          ),
          color: style["colors"]["gray"],
          padding: style["padding"]["view"],
          width: MediaQuery.of(context).size.width,
        ),
        Form(
          child: FutureBuilder(
              future: httpService.getIndicators(int.parse(widget.space.id)),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Indicator>> snapshot) {
                if (snapshot.hasData) {
                  return IndicatorsForms(indicators: snapshot.data);
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
          key: _formKey,
        ),
        Container(
          child: ButtonTheme(
            minWidth: MediaQuery.of(context).size.width,
            child: RaisedButton(
              padding: style["padding"]["button"],
              color: style["colors"]["primary"],
              shape: new RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(style["radius"]["button"])),
              onPressed: () {
                if (!_formKey.currentState.validate()) return;
                saveNewEntry(context, widget.space.id);
              },
              child: Text('Enregistrer',
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: style["button"]["size"],
                  )),
            ),
          ),
          padding: EdgeInsets.only(
            right: style["padding"]["value"],
            left: style["padding"]["value"],
            top: 10,
            bottom: 10,
          ),
          color: style["colors"]["gray"],
        )
      ],
    );
  }

  void showDatePicker(context) {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(2018, 01, 01),
        maxTime: DateTime.now(),
        onChanged: (date) {}, onConfirm: (date) {
      setState(() {
        entryDate = date;
      });
      Fluttertoast.showToast(
          msg: 'Date choisie avec succès', toastLength: Toast.LENGTH_LONG);
    }, currentTime: entryDate, locale: LocaleType.fr);
  }
}

void saveNewEntry(context, spaceId) {
  var formatter = new DateFormat('yyyy-MM-dd');
  String date = formatter.format(entryDate);
  final HttpService httpService = HttpService();

  httpService.newEntry(spaceId, date, indicatorsValues).then((id) => {
        if (id != null)
          {
            Navigator.of(context).pushReplacementNamed('/spacesList'),
            Navigator.of(context)
                .pushNamed('/singleSpace', arguments: int.parse(spaceId)),
            Fluttertoast.showToast(
                msg: 'Nouvelle saisie enregistrée avec succès',
                toastLength: Toast.LENGTH_LONG),
          }
      });
}

void setIndicatorValue(indicatorId, value) {
  for (var i = 0; i < indicatorsValues.length; i++) {
    if (indicatorsValues[i]["id"] == indicatorId) {
      indicatorsValues[i]["value"] = value;
      return;
    }
  }
  indicatorsValues.add({"id": indicatorId, "value": value});
}

class IndicatorsForms extends StatefulWidget {
  final List<Indicator> indicators;
  IndicatorsForms({Key key, this.indicators}) : super(key: key);
  @override
  _IndicatorsFormsState createState() => _IndicatorsFormsState();
}

class _IndicatorsFormsState extends State<IndicatorsForms> {
  Map<int, String> boolRadiosValues = Map();

  @override
  Widget build(BuildContext context) {
    return new Expanded(
      child: ListView.separated(
        separatorBuilder: (context, int i) => Divider(
          color: style["colors"]["gray-1"],
        ),
        itemCount: widget.indicators.length,
        itemBuilder: (BuildContext context, int i) {
          return Container(
            child: ListTile(
              title: new Text(
                widget.indicators[i].name,
                style: TextStyle(
                  fontSize: style["sub"]["size"],
                  fontFamily: style["font"]["Medium"],
                  color: style["colors"]["primary"],
                ),
                textAlign: TextAlign.left,
              ),
              subtitle: getInputField(widget.indicators[i], i, context),
              leading: Text(
                (i + 1).toString(),
                style: TextStyle(
                  fontSize: style["h4"]["size"],
                  fontFamily: style["font"]["Medium"],
                  color: style["colors"]["gray-1"],
                ),
              ),
              onTap: () {},
            ),
            padding: EdgeInsets.only(
              bottom: 15,
              top: 15,
            ),
            color: style["colors"]["white"],
          );
        },
        padding: EdgeInsets.only(
          right: style["padding"]["value"],
          left: style["padding"]["value"],
        ),
      ),
    );
  }

  getInputParams(type) {
    var dst = {};
    switch (type) {
      case 'Numérique':
        dst["keyboardType"] = TextInputType.numberWithOptions(
          decimal: false,
          signed: false,
        );
        dst["inputFormatters"] = <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly
        ];
        break;
      default:
        dst["keyboardType"] = TextInputType.text;
    }

    // STYLE
    dst["style"] = TextStyle(
        color: style["colors"]["primary"], fontSize: style["input"]["size"]);
    dst["borderSide"] =
        BorderSide(color: style["colors"]["gray-1"], width: 1.0);

    return dst;
  }

  getInputField(indicator, i, context) {
    var inputParams = getInputParams(indicator.type);
    switch (indicator.type) {
      case 'Numérique':
        return TextFormField(
          validator: (String value) {
            return value.length == 0 ? "Champ obligatoire" : null;
          },
          onChanged: (String value) {
            setIndicatorValue(indicator.id.toString(), value);
          },
          keyboardType: inputParams["keyboardType"],
          decoration: InputDecoration(
            // counterText: "Indicateur n°" +
            //     (i + 1).toString() +
            //     " sur " +
            //     (this.indicators.length).toString(),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: style["colors"]["primary"]),
            ),
            enabledBorder: new UnderlineInputBorder(
              borderSide: inputParams["borderSide"],
            ),
          ),
          style: inputParams["style"],
        );
        break;
      case 'Booléen':
        if (boolRadiosValues[int.parse(indicator.id)] == null) {
          boolRadiosValues[int.parse(indicator.id)] = "Oui";
          setIndicatorValue(int.parse(indicator.id).toString(), "Oui");
        }
        return new Row(
          children: <Widget>[
            new Radio(
              value: "Oui",
              groupValue: boolRadiosValues[int.parse(indicator.id)],
              onChanged: (value) => {
                setState(() => {boolRadiosValues[int.parse(indicator.id)] = value}),
                setIndicatorValue(int.parse(indicator.id).toString(), value),
              },
            ),
            new Text(
              'Oui',
              style: new TextStyle(fontSize: 16.0),
            ),
            new Radio(
              value: "Non",
              groupValue: boolRadiosValues[int.parse(indicator.id)],
              onChanged: (value) => {
                setState(() => {boolRadiosValues[int.parse(indicator.id)] = value}),
                setIndicatorValue(int.parse(indicator.id).toString(), value),
              },
            ),
            new Text(
              'Non',
              style: new TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        );
        // String defaultValue = "Oui";
        // setIndicatorValue(indicator.id.toString(), defaultValue);
        // return DropdownButton<String>(
        //   value: defaultValue,
        //   icon: Icon(Icons.keyboard_arrow_down),
        //   iconSize: 24,
        //   elevation: 16,
        //   style: TextStyle(color: style["colors"]["primary"]),
        //   underline: Container(
        //     height: 1,
        //     color: style["colors"]["primary"],
        //   ),
        //   isExpanded: true,
        //   onChanged: (String value) {
        //     setIndicatorValue(indicator.id.toString(), value);
        //   },
        //   items: ["Oui", "Non"].map<DropdownMenuItem<String>>((String value) {
        //     return DropdownMenuItem<String>(
        //       value: value,
        //       child: Text(value,
        //           style: TextStyle(
        //               fontSize: style["input"]["size"],
        //               fontFamily: style["font"]["SemiBold"])),
        //     );
        //   }).toList(),
        // );
        break;
      default:
        return TextFormField(
          validator: (String value) {
            return value.length == 0 ? "Champ obligatoire" : null;
          },
          keyboardType: inputParams["keyboardType"],
          decoration: InputDecoration(
            // counterText: "Indicateur n°" +
            //     (i + 1).toString() +
            //     " sur " +
            //     (this.indicators.length).toString(),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: style["colors"]["primary"]),
            ),
            enabledBorder: new UnderlineInputBorder(
              borderSide: inputParams["borderSide"],
            ),
          ),
          style: inputParams["style"],
          onChanged: (String value) {
            setIndicatorValue(indicator.id.toString(), value);
          },
        );
    }
  }
}
