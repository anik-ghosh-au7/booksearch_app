import 'dart:math';
import 'package:flutter/material.dart';
import 'package:searchbase/searchbase.dart';

typedef void SetStateCb(String id, data);

class PublicationYearFilter extends StatefulWidget {
  final SearchWidget searchWidget;
  final SetStateCb callback;
  final bool panelState;
  final Map panelData;

  PublicationYearFilter(
      this.searchWidget, this.callback, this.panelState, this.panelData);

  @override
  _PublicationYearFilterState createState() => _PublicationYearFilterState();
}

class _PublicationYearFilterState extends State<PublicationYearFilter> {
  RangeValues _currentRangeValues;
  int _key;

  var startText = '';
  var endText = '';

  void _collapse() {
    int newKey;
    do {
      _key = new Random().nextInt(10000);
    } while (newKey == _key);
  }

  @override
  void initState() {
    if (widget.searchWidget.value.isEmpty) {
      _currentRangeValues = const RangeValues(1950, 2000);
    } else {
      _currentRangeValues = RangeValues(
          double.parse(widget.searchWidget.value['start']),
          double.parse(widget.searchWidget.value['end']));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.panelState) {
      _collapse();
    }
    startText = '${_currentRangeValues.start.round().toString()}';
    endText = '${_currentRangeValues.end.round().toString()}';
    return widget.searchWidget.requestPending
        ? Center(child: CircularProgressIndicator())
        : ExpansionTile(
            key: new Key(_key.toString()),
            initiallyExpanded: widget.panelState,
            onExpansionChanged: ((newState) {
              widget.callback('publication-year-filter', newState);
            }),
            title: RichText(
              text: TextSpan(
                  text: 'Select Publication Year',
                  style: widget.panelState
                      ? Theme.of(context).textTheme.headline1
                      : Theme.of(context).textTheme.headline2),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 25, 5, 0),
                child: SliderTheme(
                  data: Theme.of(context).sliderTheme,
                  child: RangeSlider(
                    values: _currentRangeValues,
                    min: 1950,
                    max: 2010,
                    divisions: 161,
                    labels: RangeLabels(
                      _currentRangeValues.start.round().toString(),
                      _currentRangeValues.end.round().toString(),
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _currentRangeValues = values;
                        widget.searchWidget.setValue({
                          "start": _currentRangeValues.start
                              .round()
                              .toString(), // optional
                          "end": _currentRangeValues.end.round().toString(),
                        });
                      });
                      widget.callback('publication-year-data', {
                        "start": _currentRangeValues.start
                            .round()
                            .toString(), // optional
                        "end": _currentRangeValues.end.round().toString(),
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 30, 0, 0),
                child: Align(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: RichText(
                          text: TextSpan(
                            text: 'Start: ',
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(5, 3, 0, 0),
                          child: Container(
                            child: RichText(
                              text: TextSpan(
                                text: startText,
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: RichText(
                          text: TextSpan(
                            text: 'End: ',
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                          child: Container(
                            child: RichText(
                              text: TextSpan(
                                text: endText,
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
  }
}
