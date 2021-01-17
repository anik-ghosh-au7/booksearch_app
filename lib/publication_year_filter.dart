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
                  style: TextStyle(
                    fontSize: 20,
                    color: widget.panelState
                        ? Colors.blue.shade400
                        : Colors.black54,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 25, 5, 0),
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.blueGrey,
                    inactiveTrackColor: Colors.black45,
                    trackHeight: 3.0,
                    thumbColor: Colors.blueGrey,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
                    overlayColor: Colors.black.withAlpha(54),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 14.0),
                    valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                    valueIndicatorColor: Colors.black45,
                    valueIndicatorTextStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
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
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
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
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15),
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
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
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
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15),
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
