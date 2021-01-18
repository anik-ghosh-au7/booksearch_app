import 'package:flutter/material.dart';
import 'package:flutter_searchbox/flutter_searchbox.dart';

class DrawerButtons extends StatefulWidget {
  @override
  _DrawerButtonsState createState() => _DrawerButtonsState();
}

class _DrawerButtonsState extends State<DrawerButtons> {
  Map<dynamic, dynamic> searchWidgetState;
  @override
  Widget build(BuildContext context) {
    searchWidgetState = SearchBaseProvider.of(context).getActiveWidgets();
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Container(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            color: Colors.black,
            height: 70,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 6,
                    child: RaisedButton(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 23.0),
                      color: Colors.black,
                      child: Text(
                        'Apply',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        searchWidgetState['author-filter'].triggerCustomQuery();
                        searchWidgetState['ratings-filter']
                            .triggerCustomQuery();
                        searchWidgetState['publication-year-filter']
                            .triggerCustomQuery();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(
                          text: '|',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 50,
                              fontWeight: FontWeight.w100),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: RaisedButton(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 23.0),
                      color: Colors.black,
                      child: Text(
                        'Close',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
