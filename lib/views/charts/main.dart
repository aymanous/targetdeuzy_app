import 'package:flutter/material.dart';
import 'package:targetapp/fragments/header.dart';
import 'package:targetapp/custom/custom.dart';
import 'package:targetapp/models/http_service.dart';
import 'package:targetapp/models/indicator_model.dart';
import 'package:targetapp/models/indicator_model.dart';
import 'package:targetapp/views/charts/numeric.dart';
import 'package:targetapp/views/charts/bool.dart';
import 'package:targetapp/views/charts/text.dart';

class ChartsMain extends StatelessWidget {
  final indicatorId;
  const ChartsMain({Key key, this.indicatorId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HttpService httpService = HttpService();
    return Scaffold(
      appBar: Header(title: "", showActions: false),
      backgroundColor: style["colors"]["white"],
      body: FutureBuilder(
          future: httpService.getIndicator(this.indicatorId),
          builder: (BuildContext context, AsyncSnapshot<Indicator> snapshot) {
            if (snapshot.hasData) {
              return ChartCore(
                indicator: snapshot.data,
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

class ChartCore extends StatelessWidget {
  final Indicator indicator;
  const ChartCore({Key key, this.indicator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: 15),
                  child: Text(
                    this.indicator.name,
                    style: TextStyle(
                        fontSize: style["h1"]["size"],
                        fontFamily: style["font"]["Medium"],
                        color: style["colors"]["primary"]),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
            color: style["colors"]["gray"],
            padding: style["padding"]["view"],
          ),
          Expanded(child: getChart(this.indicator),)
        ],
      ),
    );
  }

  getChart(Indicator indicator) {
    switch (indicator.type) {
      case "Numérique":
        return NumericChart(indicator: indicator);
        break;
      case "Texte":
        return TextChart(indicator: indicator);
      case "Booléen":
        return BoolChart(indicator: indicator);
      default:
        return Text("Error");
    }
  }
}
