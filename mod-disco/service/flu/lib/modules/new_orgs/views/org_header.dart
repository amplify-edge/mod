import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:sys_share_sys_account_service/sys_share_sys_account_service.dart';

class NewOrgHeader extends StatelessWidget {
  final Org org;

  const NewOrgHeader({Key key, @required this.org})
      : assert(org != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: MemoryImage(Uint8List.fromList(org.logo)),
          ),
          title: Text(
            org.name,
            style: Theme.of(context).textTheme.title,
          ),
          subtitle: Text(
            org.contact,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
