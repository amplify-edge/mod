import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:sys_share_sys_account_service/sys_share_sys_account_service.dart';

class ProjectHeader extends StatelessWidget {
  final Project project;

  const ProjectHeader({Key key, @required this.project})
      : assert(project != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: MemoryImage(Uint8List.fromList(project.logo)),
          ),
          title: Text(
            project.name,
            style: Theme.of(context).textTheme.title,
          ),
          subtitle: Text(
            "Org: " + project.org.name,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
