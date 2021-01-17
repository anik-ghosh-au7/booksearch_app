import 'package:flutter/material.dart';

import 'filter_chip.dart';

class SelectedFilters extends StatefulWidget {
  final Map activeWidgets;
  SelectedFilters(this.activeWidgets);

  @override
  _SelectedFiltersState createState() => _SelectedFiltersState();
}

class _SelectedFiltersState extends State<SelectedFilters> {
  List selectedFilters;

  // @override
  // void initState() {
  //   super.initState();
  //   selectedFilters = [];
  // }

  @override
  void didUpdateWidget(SelectedFilters oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (identical(oldWidget.activeWidgets, widget.activeWidgets)) {
      print('SelectedFilters changed');
    }
  }

  void setSelectedFilters() {
    print('selected filters called');
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
    print('selected filters ==>>${selectedFilters}');
  }

  @override
  Widget build(BuildContext context) {
    this.setSelectedFilters();
    return Container(
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
                          .map((e) => filterChipWidget(
                                chipName: e['data'],
                                chipType: e['key'],
                              ))
                          .toList(),
                    ),
                  ),
                ),
                Positioned(
                    right: 0,
                    bottom: 0,
                    child: RawMaterialButton(
                      onPressed: () {
                        print('button pressed');
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
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
