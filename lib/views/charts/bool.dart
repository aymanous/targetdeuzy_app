import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:targetapp/models/http_service.dart';
import 'package:targetapp/models/indicator_model.dart';

class BoolChart extends StatelessWidget {
  final Indicator indicator;
  const BoolChart({Key key, this.indicator}) : super(key: key);

  static List<charts.Series<DataModel, int>> _createSampleData(
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
      new charts.Series<DataModel, int>(
        id: 'Bool',
        domainFn: (DataModel obj, _) => obj.occurence,
        measureFn: (DataModel obj, _) => obj.occurence,
        labelAccessorFn: (DataModel row, _) =>
            '${row.value} : ${row.occurence}', //Add this
        data: data,
      )
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
            return new charts.PieChart(_createSampleData(snapshot.data),
                animate: true,
                defaultRenderer: new charts.ArcRendererConfig(
                    arcWidth: 90,
                    arcRendererDecorators: [
                      charts.ArcLabelDecorator() // <-- and this of course
                    ]));
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
