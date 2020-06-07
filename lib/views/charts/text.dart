import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:targetapp/custom/custom.dart';
import 'package:targetapp/models/http_service.dart';
import 'package:targetapp/models/indicator_model.dart';

class TextChart extends StatelessWidget {
  final Indicator indicator;
  const TextChart({Key key, this.indicator}) : super(key: key);

  static List<charts.Series<DataModel, String>> _createSampleData(
      List<dynamic> obj) {
    List<DataModel> data = [];

    obj.forEach(
      (oc) => {
        data.add(
          DataModel(oc["value"].toString(), int.parse(oc["occurence"])),
        ),
      },
    );

    return [
      new charts.Series<DataModel, String>(
          id: 'Text',
          domainFn: (DataModel row, _) => row.value,
          measureFn: (DataModel row, _) => row.occurence,
          data: data,
          // Set a label accessor to control the text of the bar label.
          labelAccessorFn: (DataModel sales, _) =>
              '    ${sales.value} : ${sales.occurence.toString()}')
    ];
  }

  @override
  Widget build(BuildContext context) {
    final HttpService httpService = HttpService();

    return FutureBuilder(
        future: httpService
            .getIndicatorEntryOccurences(int.parse(this.indicator.id)),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            return Padding(
                padding: style["padding"]["view"],
                child: new charts.BarChart(
                  _createSampleData(snapshot.data),
                  animate: true,
                  vertical: false,
                  // Set a bar label decorator.
                  // Example configuring different styles for inside/outside:
                  //       barRendererDecorator: new charts.BarLabelDecorator(
                  //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
                  //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
                  barRendererDecorator: new charts.BarLabelDecorator<String>(),
                  // Hide domain axis.
                  domainAxis: new charts.OrdinalAxisSpec(
                      renderSpec: new charts.NoneRenderSpec()),
                ));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}

class DataModel {
  final String value;
  final int occurence;

  DataModel(this.value, this.occurence);
}
