import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FilterCheckbox extends StatelessWidget {
  final bool checkboxVal;
  final void Function(bool) onChanged;
  final String description;

  FilterCheckbox({Key key, this.checkboxVal, this.onChanged, this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
      child: Row(
        children: [
          Checkbox(
            value: checkboxVal,
            onChanged: (val) => onChanged(val),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: description,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}
