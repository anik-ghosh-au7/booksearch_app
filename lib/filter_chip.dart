import 'package:flutter/material.dart';

class filterChipWidget extends StatefulWidget {
  final String chipName;
  final String chipType;

  filterChipWidget({Key key, @required this.chipName, @required this.chipType})
      : super(key: key);

  @override
  _filterChipWidgetState createState() => _filterChipWidgetState();
}

class _filterChipWidgetState extends State<filterChipWidget> {
  var _isSelected = false;

  Icon getIcon(String chipType) {
    switch (chipType) {
      case 'author-filter':
        {
          return Icon(
            Icons.account_circle_outlined,
            color: Colors.black54,
          );
        }
      case 'ratings-filter':
        {
          return Icon(
            Icons.star_border_outlined,
            color: Colors.black54,
          );
        }
      case 'publication-year-filter':
        {
          return Icon(
            Icons.date_range_outlined,
            color: Colors.black54,
          );
        }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      showCheckmark: false,
      avatar: _isSelected
          ? Icon(
              Icons.clear_outlined,
              color: Colors.black54,
            )
          : getIcon(widget.chipType),
      label: Text(widget.chipName),
      labelStyle: TextStyle(
          color: Colors.black54, fontSize: 12.0, fontWeight: FontWeight.bold),
      selected: _isSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      backgroundColor: Colors.black12,
      onSelected: (isSelected) {
        setState(() {
          _isSelected = isSelected;
        });
      },
      selectedColor: Colors.redAccent[100],
    );
  }
}
