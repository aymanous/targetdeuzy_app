import 'package:flutter/material.dart';
import 'package:targetapp/custom/custom.dart';
import 'package:targetapp/fragments/header.dart';
import 'package:targetapp/models/entry_model.dart';
import 'package:targetapp/models/http_service.dart';
import 'package:targetapp/models/value_model.dart';

class SingleEntry extends StatelessWidget {
  final Entry entry;
  const SingleEntry({Key key, this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HttpService httpService = HttpService();

    return Scaffold(
      appBar: Header(title: "Mes espaces", showActions: true),
      backgroundColor: style["colors"]["white"],
      body: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text(
                    this.entry.spaceName,
                    style: TextStyle(
                        fontSize: style["h1"]["size"],
                        fontFamily: style["font"]["Medium"],
                        color: style["colors"]["primary"]),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  child: Text(
                    "Saisie du " +
                        dateFormatting(
                            DateTime.parse(this.entry.date)),
                    style: TextStyle(
                        fontSize: style["sub"]["size"],
                        fontFamily: style["font"]["Regular"],
                        color: style["colors"]["disabled"]),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            color: style["colors"]["gray"],
            padding: style["padding"]["view"],
            margin: EdgeInsets.only(bottom: 20),
          ),
          FutureBuilder(
            future:
                httpService.getEntryIndicatorsValues(int.parse(this.entry.id)),
            builder:
                (BuildContext context, AsyncSnapshot<List<Value>> snapshot) {
              if (snapshot.hasData && snapshot.data.length > 0) {
                return IndicatorsValuesList(values: snapshot.data);
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class IndicatorsValuesList extends StatelessWidget {
  final List<Value> values;
  const IndicatorsValuesList({Key key, this.values}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Expanded(
      child: ListView.separated(
        separatorBuilder: (context, int i) =>
            Divider(color: style["colors"]["gray-1"]),
        itemCount: this.values.length,
        itemBuilder: (BuildContext context, int i) {
          return ListTile(
            title: new Text(
              this.values[i].indicatorName,
              style: TextStyle(
                  fontSize: style["h4"]["size"],
                  fontFamily: style["font"]["Regular"],
                  color: style["colors"]["disabled"]),
              textAlign: TextAlign.left,
            ),
            subtitle: new Text(this.values[i].value,
                style: TextStyle(
                    fontSize: style["h4"]["size"],
                    fontFamily: style["font"]["Bold"],
                    color: style["colors"]["primary"])),
            onTap: () {},
          );
        },
        padding: EdgeInsets.only(
            right: style["padding"]["value"],
            left: style["padding"]["value"],
            bottom: style["padding"]["value"]),
      ),
    );
  }
}
