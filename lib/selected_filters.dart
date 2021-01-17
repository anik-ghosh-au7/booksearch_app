import 'package:flutter/material.dart';

import 'filter_chip.dart';

typedef void SetStateCb(String id, data);

class SelectedFilters extends StatefulWidget {
  final Map activeWidgets;
  final SetStateCb callback;
  SelectedFilters(this.activeWidgets, this.callback);

  @override
  _SelectedFiltersState createState() => _SelectedFiltersState();
}

class _SelectedFiltersState extends State<SelectedFilters> {
  List selectedFilters;
  List toBeRemovedFilters;

  @override
  void initState() {
    selectedFilters = [];
    toBeRemovedFilters = [];
    super.initState();
  }

  // @override
  // void didUpdateWidget(SelectedFilters oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (identical(oldWidget.activeWidgets, widget.activeWidgets)) {
  //     print('SelectedFilters changed');
  //   }
  // }

  void setSelectedFilters() {
    selectedFilters = [];
    if (widget.activeWidgets['author-filter'] != null) {
      widget.activeWidgets['author-filter'].componentQuery['value']
          .forEach((element) {
        setState(() {
          selectedFilters.add({
            'key': 'author-filter',
            'value': element,
            'data': element,
          });
        });
      });
    }
    if (widget.activeWidgets['publication-year-filter'] != null &&
        widget.activeWidgets['publication-year-filter'].componentQuery['value']
                ['start'] !=
            null) {
      setState(() {
        selectedFilters.add({
          'key': 'publication-year-filter',
          'value': widget
              .activeWidgets['publication-year-filter'].componentQuery['value'],
          'data':
              '${widget.activeWidgets['publication-year-filter'].componentQuery['value']['start']} - ${widget.activeWidgets['publication-year-filter'].componentQuery['value']['end']}',
        });
      });
    }
    if (widget.activeWidgets['ratings-filter'] != null &&
        widget.activeWidgets['ratings-filter'].componentQuery['value']
                ['start'] !=
            null) {
      setState(() {
        selectedFilters.add({
          'key': 'ratings-filter',
          'value':
              widget.activeWidgets['ratings-filter'].componentQuery['value'],
          'data':
              '${widget.activeWidgets['ratings-filter'].componentQuery['value']['start']} - ${widget.activeWidgets['ratings-filter'].componentQuery['value']['end']}',
        });
      });
    }
  }

  void setToBeRemovedFilters(String key, value) {
    switch (key) {
      case 'author-filter':
        {
          var itemIndex = toBeRemovedFilters.indexWhere((filter) =>
              (filter['key'] == 'author-filter' && filter['value'] == value));
          if (itemIndex == -1) {
            setState(() {
              toBeRemovedFilters.add({
                'key': key,
                'value': value,
              });
            });
          } else {
            setState(() {
              toBeRemovedFilters.removeAt(itemIndex);
            });
          }
          break;
        }
      case 'ratings-filter':
        {
          var itemIndex = toBeRemovedFilters.indexWhere((filter) =>
              (filter['key'] == 'ratings-filter' &&
                  filter['value']['start'] == value['start']));
          if (itemIndex == -1) {
            setState(() {
              toBeRemovedFilters.add({
                'key': key,
                'value': {
                  'start': value['start'],
                  'end': value['end'],
                },
              });
            });
          } else {
            setState(() {
              toBeRemovedFilters.removeAt(itemIndex);
            });
          }
          break;
        }
      case 'publication-year-filter':
        {
          var itemIndex = toBeRemovedFilters.indexWhere((filter) =>
              (filter['key'] == 'publication-year-filter' &&
                  filter['value']['start'] == value['start'] &&
                  filter['value']['end'] == value['end']));
          if (itemIndex == -1) {
            setState(() {
              toBeRemovedFilters.add({
                'key': key,
                'value': {
                  'start': value['start'],
                  'end': value['end'],
                },
              });
            });
          } else {
            setState(() {
              toBeRemovedFilters.removeAt(itemIndex);
            });
          }
          break;
        }
    }
  }

  void removeFilters() {
    toBeRemovedFilters.forEach((filter) {
      if (filter['key'] == 'author-filter') {
        final List<String> values =
            widget.activeWidgets['author-filter'].value == null
                ? []
                : widget.activeWidgets['author-filter'].value;
        values.remove(filter['value']);
        widget.activeWidgets['author-filter'].setValue(values);
        widget.callback('author-data', values);
      } else if (filter['key'] == 'ratings-filter') {
        widget.activeWidgets['ratings-filter'].setValue({});
        widget.callback(filter['ratings-data'], {});
      } else if (filter['key'] == 'publication-year-filter') {
        widget.activeWidgets['publication-year-filter'].setValue({});
        widget.callback(filter['publication-year-data'], {});
      }
    });
    setState(() {
      toBeRemovedFilters = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    this.setSelectedFilters();
    return Visibility(
      visible: selectedFilters.length > 0,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          height: 240,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 10),
                  child: RichText(
                    text: TextSpan(
                      text: 'Selected Filters',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 206,
                width: 300,
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                        child: Wrap(
                          spacing: 1.0,
                          runSpacing: 1.0,
                          children: selectedFilters
                              .map(
                                (element) => FilterChipWidget(
                                  chipName: element['data'],
                                  chipType: element['key'],
                                  chipValue: element['value'],
                                  removeFiltersCb: setToBeRemovedFilters,
                                  selected: (() {
                                    var flag = false;
                                    toBeRemovedFilters.forEach((filter) {
                                      if (filter['key'] == element['key']) {
                                        if (filter['key'] == 'author-filter' &&
                                            filter['value'] ==
                                                element['value']) {
                                          flag = true;
                                        }
                                        if (filter['key'] == 'ratings-filter' ||
                                            filter['key'] ==
                                                'publication-year-filter') {
                                          if (filter['value']['start'] ==
                                                  element['value']['start'] &&
                                              filter['value']['end'] ==
                                                  element['value']['end']) {
                                            flag = true;
                                          }
                                        }
                                      }
                                    });
                                    return flag;
                                  })(),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: toBeRemovedFilters.length > 0,
                      child: Positioned(
                        right: 0,
                        bottom: 0,
                        child: RawMaterialButton(
                          onPressed: () {
                            removeFilters();
                          },
                          elevation: 5.0,
                          fillColor: Colors.blue.withOpacity(0.5),
                          child: Icon(
                            Icons.delete_forever_rounded,
                            size: 25.0,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(10.0),
                          shape: CircleBorder(),
                          splashColor: Colors.redAccent[100],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
