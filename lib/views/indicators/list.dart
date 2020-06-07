import 'package:flutter/material.dart';
import 'package:targetapp/custom/custom.dart';
import 'package:targetapp/models/http_service.dart';
import 'package:targetapp/models/indicator_model.dart';
import 'package:targetapp/views/indicators/modals/edit.dart';

class IndicatorsList extends StatelessWidget {
  final int spaceId;
  const IndicatorsList({Key key, this.spaceId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HttpService httpService = HttpService();

    return FutureBuilder(
        future: httpService.getIndicators(this.spaceId),
        builder:
            (BuildContext context, AsyncSnapshot<List<Indicator>> snapshot) {
          if (snapshot.hasData && snapshot.data.length > 0) {
            return IndicatorsListElements(indicators: snapshot.data);
          } else {
            return NoIndicatorAvailabe();
          }
        });
  }
}

class IndicatorsListElements extends StatelessWidget {
  final List<Indicator> indicators;
  const IndicatorsListElements({Key key, this.indicators}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Expanded(
      child: ListView.separated(
        separatorBuilder: (context, int i) =>
            Divider(color: style["colors"]["gray-1"]),
        itemCount: this.indicators.length,
        itemBuilder: (BuildContext context, int i) {
          return ListTile(
            title: new Text(
              this.indicators[i].name,
              style: TextStyle(
                  fontSize: style["h4"]["size"],
                  fontFamily: style["font"]["Regular"],
                  color: style["colors"]["disabled"]),
              textAlign: TextAlign.left,
            ),
            subtitle: new Text(this.indicators[i].type,
                style: TextStyle(
                    fontSize: style["medium"]["size"],
                    fontFamily: style["font"]["Light"],
                    color: style["colors"]["primary"])),
            trailing: new IconButton(
                icon: new Icon(
                  Icons.edit,
                  size: 20,
                  color: style["colors"]["primary"],
                ),
                onPressed: () {
                  showEditIndicatorModal(context, int.parse(this.indicators[i].id));
                }),
            onTap: () {
              Navigator.of(context).pushNamed('/chart',
                  arguments: int.parse(this.indicators[i].id));
            },
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

class NoIndicatorAvailabe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Expanded(
        child: Column(children: <Widget>[
      Padding(
          padding: EdgeInsets.only(
            right: style["padding"]["value"],
            left: style["padding"]["value"],
            bottom: 0,
            top: 0,
          ),
          child: Image.asset("assets/images/empty-cart.gif")),
    ]));
  }
}
