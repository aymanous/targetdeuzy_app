import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:targetapp/custom/custom.dart';
import 'package:targetapp/models/http_service.dart';
import 'package:targetapp/models/indicator_model.dart';

class NumericChart extends StatelessWidget {
  final Indicator indicator;
  const NumericChart({Key key, this.indicator}) : super(key: key);

  static List<charts.Series<DataModel, DateTime>> _createSampleData(
      List<dynamic> obj) {
    List<DataModel> data = [];

    obj.forEach(
      (oc) => {
        data.add(
          new DataModel(DateTime.parse(oc["date"]), int.parse(oc["value"])),
        ),
      },
    );

    return [
      new charts.Series<DataModel, DateTime>(
        id: 'Numeric',
        domainFn: (DataModel row, _) => row.date,
        measureFn: (DataModel row, _) => row.value,
        data: data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    final HttpService httpService = HttpService();

    return FutureBuilder(
        future: httpService
            .getNumericIndicatorEntryOccurences(int.parse(this.indicator.id)),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: style["padding"]["view"],
              child:
                  new charts.TimeSeriesChart(_createSampleData(snapshot.data),
                      animate: true,

                      /// Customize the gridlines to use a dash pattern.
                      primaryMeasureAxis: new charts.NumericAxisSpec(
                          renderSpec: charts.GridlineRendererSpec(
                              lineStyle: charts.LineStyleSpec(
                        dashPattern: [4, 4],
                      )))),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}

class DataModel {
  final DateTime date;
  final int value;

  DataModel(this.date, this.value);
}
