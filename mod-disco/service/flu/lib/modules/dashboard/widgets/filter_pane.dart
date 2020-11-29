import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:responsive_builder/responsive_builder.dart';

class FilterPane extends StatelessWidget {
  final SizingInformation sizingInfo;

  const FilterPane({Key key, this.sizingInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return ViewModelProvider.withConsumer(
    //   viewModelBuilder: () => FilterPaneViewModel()
    // );
    return _filterPane(context, sizingInfo);
  }

  Widget _filterPane(context, SizingInformation sizingInfo) {
    return Container(
      width: sizingInfo.localWidgetSize.width * 0.25,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
              child: Text(
                "Filter",
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Divider(
              height: 0,
            ),
            _conditions(context),
            Divider(height: 0),
            _roles(context),
            Divider(height: 0),
            _date(context),
          ],
        ),
      ),
    );
  }

  Widget _conditions(context) {
    return ExpansionTile(
      title: Text(
        "Conditions",
        style: Theme.of(context)
            .textTheme
            .bodyText1
            .copyWith(fontWeight: FontWeight.bold),
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
          child: Row(
            children: <Widget>[
              Checkbox(value: true, onChanged: (value) {}),
              Text("Free Child care",
                  style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
          child: Row(
            children: <Widget>[
              Checkbox(value: true, onChanged: (value) {}),
              Text("Transport to and back",
                  style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
          child: Row(
            children: <Widget>[
              Checkbox(value: false, onChanged: (value) {}),
              Text("Invited by a freind",
                  style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
          child: Row(
            children: <Widget>[
              Checkbox(value: false, onChanged: (value) {}),
              Text("Candidate has 50%\nchance of winning",
                  style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
        ),
      ],
    );
  }

  Widget _roles(context) {
    return ExpansionTile(
      title: Text(
        "Roles",
        style: Theme.of(context)
            .textTheme
            .bodyText1
            .copyWith(fontWeight: FontWeight.bold),
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
          child: Row(
            children: <Widget>[
              Checkbox(value: true, onChanged: (value) {}),
              Text("Canvesser/ Field\norganizer",
                  style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
          child: Row(
            children: <Widget>[
              Checkbox(value: true, onChanged: (value) {}),
              Text("Phonebanker", style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
          child: Row(
            children: <Widget>[
              Checkbox(value: false, onChanged: (value) {}),
              Text("Social Media Help",
                  style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
          child: Row(
            children: <Widget>[
              Checkbox(value: false, onChanged: (value) {}),
              Text("Digital Marketing Help",
                  style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
        ),
      ],
    );
  }

  Widget _date(context) {
    return ExpansionTile(
      title: Text(
        "Date",
        style: Theme.of(context)
            .textTheme
            .bodyText1
            .copyWith(fontWeight: FontWeight.bold),
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
          child: Row(
            children: <Widget>[
              Checkbox(value: true, onChanged: (value) {}),
              Text("Canvesser/ Field\norganizer",
                  style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
          child: Row(
            children: <Widget>[
              Checkbox(value: true, onChanged: (value) {}),
              Text("Phonebanker", style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
          child: Row(
            children: <Widget>[
              Checkbox(value: false, onChanged: (value) {}),
              Text("Social Media Help",
                  style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
          child: Row(
            children: <Widget>[
              Checkbox(value: false, onChanged: (value) {}),
              Text("Digital Marketing Help",
                  style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
        ),
      ],
    );
  }

  Widget _rewards(context) {
    return ExpansionTile(
      title: Text(
        "Rewards",
        style: Theme.of(context)
            .textTheme
            .bodyText1
            .copyWith(fontWeight: FontWeight.bold),
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
          child: Row(
            children: <Widget>[
              Checkbox(value: true, onChanged: (value) {}),
              Text("Canvesser/ Field\norganizer",
                  style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
          child: Row(
            children: <Widget>[
              Checkbox(value: true, onChanged: (value) {}),
              Text("Phonebanker", style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
          child: Row(
            children: <Widget>[
              Checkbox(value: false, onChanged: (value) {}),
              Text("Social Media Help",
                  style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
          child: Row(
            children: <Widget>[
              Checkbox(value: false, onChanged: (value) {}),
              Text("Digital Marketing Help",
                  style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
        ),
      ],
    );
  }
}
