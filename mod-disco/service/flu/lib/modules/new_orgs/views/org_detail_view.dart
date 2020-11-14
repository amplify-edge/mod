import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sys_share_sys_account_service/sys_share_sys_account_service.dart';
import './org_header.dart';
import '../../../core/core.dart';

class NewOrgDetailView extends StatelessWidget {
  final Org org;
  final bool showBackButton;

  const NewOrgDetailView({Key key, this.org, this.showBackButton = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: showBackButton,
        title: Text(
            ModDiscoLocalizations.of(context).translate('campaignDetails')),
      ),
      body: Column(
        children: <Widget>[
          NewOrgHeader(
            org: org,
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                //   CarouselWithIndicator(imgList: campaign.videoURL),
                ListTile(
                  title: Text(
                    ModDiscoLocalizations.of(context).translate('campaignName'),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  subtitle: Text(org.name),
                ),
                const SizedBox(height: 16.0),
                ListTile(
                  title: Text(
                    ModDiscoLocalizations.of(context)
                        .translate('contactDetails'),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  subtitle: Text(org.contact),
                ),
                const SizedBox(height: 16.0),
                ButtonBar(children: [
                  FlatButton(
                    onPressed: () {
                      Modular.to.pushNamed(Modular.get<Paths>()
                          .myNeeds
                          .replaceAll(':id', org.id));
                    },
                    child: Text(ModDiscoLocalizations.of(context)
                        .translate("notReady")),
                  ),
                  RaisedButton(
                    onPressed: () {
                      Modular.to.pushNamed('/account/signup');
                    },
                    child: Text(
                        ModDiscoLocalizations.of(context).translate("ready")),
                  ),
                ]),
                const SizedBox(height: 8.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
