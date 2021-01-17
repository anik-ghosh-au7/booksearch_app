import 'dart:math';

import 'star_display.dart';
import 'package:flutter/material.dart';
import 'package:searchbase/searchbase.dart';

typedef void SetStateCb(String id, bool status);

class RatingsFilter extends StatefulWidget {
  final SearchWidget searchWidget;
  // ignore: non_constant_identifier_names
  final SetStateCb Callback;
  final bool panelState;

  const RatingsFilter(this.searchWidget, this.Callback, this.panelState);

  @override
  _RatingsFilterState createState() => _RatingsFilterState();
}

class _RatingsFilterState extends State<RatingsFilter> {
  Map<String, String> range = {'start': '0', 'end': '5'};
  int _key;

  void _collapse() {
    int newKey;
    do {
      _key = new Random().nextInt(10000);
    } while (newKey == _key);
  }

  @override
  void initState() {
    if (widget.searchWidget.value.isNotEmpty) {
      range['start'] = widget.searchWidget.value['start'];
      range['end'] = widget.searchWidget.value['end'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.panelState) {
      _collapse();
    }
    return widget.searchWidget.requestPending
        ? Center(child: CircularProgressIndicator())
        : ExpansionTile(
            key: new Key(_key.toString()),
            initiallyExpanded: widget.panelState,
            onExpansionChanged: ((newState) {
              widget.Callback('ratings-filter', newState);
            }),
            title: RichText(
              text: TextSpan(
                  text: 'Select Ratings',
                  style: TextStyle(
                    fontSize: 20,
                    color: widget.panelState
                        ? Colors.blue.shade400
                        : Colors.black54,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            children: [
              Container(
                child: Column(
                  children: List.generate(4, (index) {
                    return GestureDetector(
                      onTap: () {
                        if (int.parse(range['start']) != (index + 1)) {
                          setState(() {
                            range = {
                              'start': (index + 1).toString(),
                              'end': '5',
                            };
                            widget.searchWidget.setValue(range);
                          });
                          // widget.searchWidget.triggerCustomQuery();
                        }
                      },
                      child: Container(
                        decoration: new BoxDecoration(
                          color: (int.parse(range['start']) == (index + 1))
                              ? Colors.black12.withOpacity(0.025)
                              : Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: IconTheme(
                                  data: IconThemeData(
                                    color: Colors.amber,
                                  ),
                                  child: StarDisplay(value: index + 1),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  child: RichText(
                                    text: TextSpan(
                                      text: '(${index + 1} stars or above)',
                                      style: TextStyle(
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          );
  }
}