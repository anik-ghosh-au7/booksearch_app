import 'dart:math';

import 'package:flutter/material.dart';
import 'package:searchbase/searchbase.dart';

class FilterHeader extends PreferredSize {
  final double height;
  final Widget child;

  FilterHeader({@required this.child, this.height = kToolbarHeight});

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      // color: Colors.white,
      alignment: Alignment.centerLeft,
      child: child,
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
        color: Colors.white,
      ),
    );
  }
}

typedef void SetStateCb(String id, bool status);

class AuthorFilter extends StatefulWidget {
  final SearchWidget searchWidget;
  // ignore: non_constant_identifier_names
  final SetStateCb Callback;
  final bool panelState;

  AuthorFilter(this.searchWidget, this.Callback, this.panelState);

  @override
  _AuthorFilterState createState() => _AuthorFilterState();
}

class _AuthorFilterState extends State<AuthorFilter> {
  int _key;

  void _collapse() {
    int newKey;
    do {
      _key = new Random().nextInt(10000);
    } while (newKey == _key);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.panelState) {
      _collapse();
    }
    print('rebuilding author-filter');
    return widget.searchWidget.requestPending
        ? Center(child: CircularProgressIndicator())
        : ExpansionTile(
            key: new Key(_key.toString()),
            initiallyExpanded: widget.panelState,
            onExpansionChanged: ((newState) {
              widget.Callback('author-filter', newState);
            }),
            title: RichText(
              text: TextSpan(
                  text: 'Select Authors',
                  style: TextStyle(
                    fontSize: 20,
                    color: widget.panelState
                        ? Colors.blue.shade400
                        : Colors.black54,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            children: [
              SizedBox(
                height: 275,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children:
                        widget.searchWidget.aggregationData.data.map((bucket) {
                      return Column(
                        children: [
                          new CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: Colors.black54,
                            dense: true,
                            title: RichText(
                              text: TextSpan(
                                text:
                                    "${bucket['_key']} (${bucket['_doc_count']})",
                                style: TextStyle(color: Colors.black87),
                              ),
                            ),
                            value: (widget.searchWidget.value == null
                                    ? []
                                    : widget.searchWidget.value)
                                .contains(bucket['_key']),
                            onChanged: (bool value) {
                              final List<String> values =
                                  widget.searchWidget.value == null
                                      ? []
                                      : widget.searchWidget.value;
                              if (values.contains(bucket['_key'])) {
                                values.remove(bucket['_key']);
                              } else {
                                values.add(bucket['_key']);
                              }
                              widget.searchWidget.setValue(values);
                              // widget.searchWidget.triggerCustomQuery();
                            },
                          ),
                          const Divider(
                            color: Colors.black,
                            height: 10,
                            thickness: 0.1,
                            indent: 25,
                            endIndent: 20,
                          )
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          );
  }
}
