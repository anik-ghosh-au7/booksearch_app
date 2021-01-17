import 'package:flutter/material.dart';
import 'package:searchbase/searchbase.dart';
import 'package:flutter_searchbox/flutter_searchbox.dart';
import 'results.dart';
import 'package:flutter_config/flutter_config.dart';
import 'author_filter.dart';
import 'publication_year_filter.dart';
import 'ratings_filter.dart';
import 'drawer_buttons.dart';
import 'selected_filters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig
  await FlutterConfig.loadEnvVariables();

  runApp(FlutterSearchBoxApp());
}

class FlutterSearchBoxApp extends StatelessWidget {
  final SearchBase searchbase;
  final index = FlutterConfig.get("INDEX");
  final credentials = FlutterConfig.get("CREDENTIALS");
  final url = FlutterConfig.get("URL");

  FlutterSearchBoxApp({Key key, this.searchbase}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The StoreProvider should wrap your MaterialApp or WidgetsApp. This will
    // ensure all routes have access to the store.
    return SearchBaseProvider(
      // Pass the store to the StoreProvider. Any ancestor `StoreConnector`
      // Widgets will find and use this value as the `Store`.
      searchbase: SearchBase(index, url, credentials,
          appbaseConfig: AppbaseSettings(recordAnalytics: true)),
      child: MaterialApp(
        title: "SearchBox Demo",
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var panelState = {};
  var searchWidgetState = {};
  var activeWidgets;

  @override
  void initState() {
    super.initState();
    panelState = {
      'author-filter': false,
      'author-data': [],
      'ratings-filter': false,
      'ratings-data': {},
      'publication-year-filter': false,
      'publication-year-data': {},
    };
    searchWidgetState = {
      'author-filter': SearchWidget,
      'ratings-filter': SearchWidget,
      'publication-year-filter': SearchWidget,
    };
  }

  void setPanelState(id, value) {
    switch (id) {
      case 'author-filter':
        {
          if (value) {
            setState(() {
              panelState['ratings-filter'] = false;
              panelState['publication-year-filter'] = false;
            });
          }
          setState(() {
            panelState['author-filter'] = value;
          });
          break;
        }
      case 'ratings-filter':
        {
          if (value) {
            setState(() {
              panelState['author-filter'] = false;
              panelState['publication-year-filter'] = false;
            });
          }
          setState(() {
            panelState['ratings-filter'] = value;
          });
          break;
        }
      case 'publication-year-filter':
        {
          if (value) {
            setState(() {
              panelState['author-filter'] = false;
              panelState['ratings-filter'] = false;
            });
          }
          setState(() {
            panelState['publication-year-filter'] = value;
          });
          break;
        }
      case 'author-data':
        {
          setState(() {
            panelState['author-data'] = value;
          });
          break;
        }
      case 'ratings-data':
        {
          setState(() {
            panelState['ratings-data'] = value;
          });
          break;
        }
      case 'publication-year-data':
        {
          setState(() {
            panelState['publication-year-data'] = value;
          });
          break;
        }
    }
  }

  void setSearchWidgetState(activeWidgets) {
    setState(() {
      searchWidgetState['author-filter'] = activeWidgets['author-filter'];
      searchWidgetState['ratings-filter'] = activeWidgets['ratings-filter'];
      searchWidgetState['publication-year-filter'] =
          activeWidgets['publication-year-filter'];
    });
  }

  @override
  Widget build(BuildContext context) {
    activeWidgets = SearchBaseProvider.of(context).getActiveWidgets();
    setSearchWidgetState(activeWidgets);
    return MaterialApp(
      title: 'SearchBox Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        // key: _scaffoldKey,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  // Invoke the Search Delegate to display search UI with autosuggestions
                  showSearch(
                      context: context,
                      // SearchBox widget from flutter searchbox
                      delegate: SearchBox(
                        // A unique identifier that can be used by other widgetss to reactively update data
                        id: 'search-widget',
                        enableRecentSearches: true,
                        enablePopularSuggestions: true,
                        showAutoFill: true,
                        maxPopularSuggestions: 3,
                        size: 10,
                        dataField: [
                          {'field': 'original_title', 'weight': 1},
                          {'field': 'original_title.search', 'weight': 3}
                        ],
                      ));
                }),
          ],
          title: Text('SearchBox Demo'),
        ),
        body: Center(
          // A custom UI widget to render a list of results
          child: SearchWidgetConnector(
              id: 'result-widget',
              dataField: 'original_title',
              react: {
                'and': [
                  'search-widget',
                  'author-filter',
                  'publication-year-filter',
                  'ratings-filter',
                ],
              },
              size: 10,
              triggerQueryOnInit: true,
              preserveResults: true,
              builder: (context, searchWidget) => ResultsWidget(searchWidget)),
        ),
        // A custom UI widget to render a list of authors
        drawer: Drawer(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      SelectedFilters(activeWidgets),
                      Container(
                        height: panelState['author-filter'] ? 350 : 60,
                        child: SearchWidgetConnector(
                          id: 'author-filter',
                          type: QueryType.term,
                          dataField: "authors.keyword",
                          size: 5,
                          // Initialize with default value
                          value: List<String>(),
                          react: {
                            'and': ['search-widget']
                          },
                          builder: (context, searchWidget) {
                            // Call searchWidget's query at first time
                            if (searchWidget.query == null) {
                              searchWidget.triggerDefaultQuery();
                            }
                            return AuthorFilter(
                                searchWidget,
                                setPanelState,
                                panelState['author-filter'],
                                panelState['author-data']);
                          },
                          // Avoid fetching query for each open/close action instead call it manually
                          triggerQueryOnInit: false,
                          // Do not remove the search widget's instance after unmount
                          destroyOnDispose: false,
                        ),
                      ),
                      Container(
                        height:
                            panelState['publication-year-filter'] ? 200 : 60,
                        child: SearchWidgetConnector(
                          id: 'publication-year-filter',
                          type: QueryType.range,
                          dataField: "original_publication_year",
                          // Initialize with default value
                          value: Map<String, String>(),
                          builder: (context, searchWidget) {
                            // Call searchWidget's query at first time
                            if (searchWidget.query == null) {
                              searchWidget.triggerDefaultQuery();
                            }
                            return PublicationYearFilter(
                                searchWidget,
                                setPanelState,
                                panelState['publication-year-filter'],
                                panelState['publication-year-data']);
                          },
                          // Avoid fetching query for each open/close action instead call it manually
                          triggerQueryOnInit: false,
                          // Do not remove the search widget's instance after unmount
                          destroyOnDispose: false,
                        ),
                      ),
                      Container(
                        height: panelState['ratings-filter'] ? 250 : 60,
                        child: SearchWidgetConnector(
                          id: 'ratings-filter',
                          type: QueryType.range,
                          dataField: "average_rating",
                          // Initialize with default value
                          value: Map<String, String>(),
                          builder: (context, searchWidget) {
                            // Call searchWidget's query at first time
                            if (searchWidget.query == null) {
                              searchWidget.triggerDefaultQuery();
                            }
                            return RatingsFilter(
                                searchWidget,
                                setPanelState,
                                panelState['ratings-filter'],
                                panelState['ratings-data']);
                          },
                          // Avoid fetching query for each open/close action instead call it manually
                          triggerQueryOnInit: false,
                          // Do not remove the search widget's instance after unmount
                          destroyOnDispose: false,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: DrawerButtons(searchWidgetState),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
