import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:targetapp/custom/custom.dart';
import 'package:targetapp/fragments/header.dart';
import 'package:targetapp/fragments/navigation.dart';
import 'package:targetapp/models/entry_model.dart';
import 'package:targetapp/models/http_service.dart';
import 'package:targetapp/plugins/date_picker/flutter_datetime_picker.dart';
import 'package:flutter/scheduler.dart';

class EntriesHistory extends StatefulWidget {
  final int userId;
  EntriesHistory({Key key, this.userId}) : super(key: key);

  @override
  _EntriesHistoryState createState() => _EntriesHistoryState();
}

class _EntriesHistoryState extends State<EntriesHistory> {
  final HttpService httpService = HttpService();
  List<Entry> entries;
  dynamic date;

  @override
  void initState() {
    super.initState();
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance
          .addPostFrameCallback((_) => showDatePicker(context));
    }

    date = DateTime.now();
    entries = List<Entry>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(title: "Historique des saisies", showActions: true),
      backgroundColor: style["colors"]["white"],
      body: Padding(
        padding: style["padding"]["view"],
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Column(
                children: <Widget>[
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
                      child: Text(dateFormatting(this.date),
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
              width: MediaQuery.of(context).size.width,
            ),
            FutureBuilder(
              future: httpService.getUserEntriesByDate(
                  widget.userId, this.date.toString()),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Entry>> snapshot) {
                if (snapshot.hasData && snapshot.data.length > 0) {
                  this.entries = snapshot.data;
                  return EntriesList(entries: this.entries);
                } else {
                  return NoEntryAvailabe(date: this.date.toString());
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Navigation(index: 2),
    );
  }

  void showDatePicker(context) {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(2018, 01, 01),
        maxTime: DateTime.now(),
        onChanged: (date) {}, onConfirm: (date) {
      setState(() {
        this.date = date;
      });
      Fluttertoast.showToast(
          msg: 'Date choisie avec succès', toastLength: Toast.LENGTH_LONG);
    }, currentTime: this.date, locale: LocaleType.fr);
  }
}

class EntriesList extends StatelessWidget {
  final List<Entry> entries;
  const EntriesList({Key key, this.entries}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Expanded(
        child: ListView.separated(
          separatorBuilder: (_, int i) => Divider(
            color: style["colors"]["gray-1"],
          ),
          itemCount: this.entries.length,
          itemBuilder: (_, int i) {
            return ListTile(
              contentPadding: EdgeInsets.all(0),
              title: new Text(this.entries[i].spaceName,
                  style: TextStyle(
                      fontSize: style["h3"]["size"],
                      fontFamily: style["font"]["Medium"],
                      color: style["colors"]["primary"])),
              subtitle: new Text(
                  "Saisie du " +
                      dateFormatting(
                          DateTime.parse(this.entries[i].date)),
                  style: TextStyle(
                      fontSize: style["sub"]["size"],
                      fontFamily: style["font"]["Regular"],
                      color: style["colors"]["disabled"])),
              trailing: new IconButton(
                  icon: new Icon(
                    Icons.keyboard_arrow_right,
                    color: style["colors"]["primary"],
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed('/singleEntry', arguments: this.entries[i]);
                  }),
              onTap: () {
                Navigator.of(context)
                    .pushNamed('/singleEntry', arguments: this.entries[i]);
              },
            );
          },
        ),
      ),
    );
  }
}

class NoEntryAvailabe extends StatelessWidget {
  final String date;
  const NoEntryAvailabe({Key key, this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40),
      child: Column(children: <Widget>[
        Text("Historique indisponible",
            style: TextStyle(
                fontSize: style["h1"]["size"],
                fontFamily: style["font"]["Regular"],
                color: style["colors"]["primary"])),
        Text(
            "Aucune saisie faite le " +
                dateFormatting(DateTime.parse(this.date)),
            style: TextStyle(
                fontSize: style["h4"]["size"],
                fontFamily: style["font"]["Light"],
                color: const Color(0xFF555555))),
        Padding(
            padding: EdgeInsets.only(top: 25, right: 50, bottom: 0, left: 50),
            child: Image.asset("assets/images/empty-cart.gif")),
        const SizedBox(height: 30),
      ]),
    );
  }
}
