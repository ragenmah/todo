import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:contacts_app/contactsPage.dart';
import 'contactPages.dart';

class SeeContactsButton extends StatefulWidget {
  @override
  _SeeContactsButtonState createState() => _SeeContactsButtonState();
}

class _SeeContactsButtonState extends State<SeeContactsButton> {
  PermissionStatus _status;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PermissionHandler()
        .checkPermissionStatus(PermissionGroup.contacts)
        .then(_updateStatus);
    _askPermission();
    onLoad();
  }

  void _updateStatus(PermissionStatus status) {
    if (status != _status) {
      setState(() {
        _status = status;
      });
    }
  }

  void _askPermission() {
    PermissionHandler().requestPermissions([PermissionGroup.contacts]).then(
        _onStatusRequested);
  }

  void _onStatusRequested(Map<PermissionGroup, PermissionStatus> statuses) {
    final status = statuses[PermissionGroup.contacts];
    if (status != PermissionStatus.granted) {
      PermissionHandler().openAppSettings();
    } else {
      _updateStatus(status);
    }
  }

  Future onLoad() async {
    final PermissionStatus permissionStatus = await _getPermission();
    if (permissionStatus == PermissionStatus.granted) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ContactsPage()));
    } else {
      //If permissions have been denied show standard cupertino alert dialog
      // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: Text('Permissions error'),
                content: Text('Please enable contacts access '
                    'permission in system settings'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RaisedButton(
          onPressed: () async {
            final PermissionStatus permissionStatus = await _getPermission();
            if (permissionStatus == PermissionStatus.granted) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ContactsPage()));
            } else {
              //If permissions have been denied show standard cupertino alert dialog
              // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              showDialog(
                  context: context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                        title: Text('Permissions error'),
                        content: Text('Please enable contacts access '
                            'permission in system settings'),
                        actions: <Widget>[
                          CupertinoDialogAction(
                            child: Text('OK'),
                            onPressed: () => Navigator.of(context).pop(),
                          )
                        ],
                      ));
            }
          },
          child: Container(child: Text('See Contacts ::  $_status')),
        ),
        RaisedButton(
          onPressed: _askPermission,
          child: Text('ask permission'),
        )
      ],
    );
  }

  //Check contacts permission
  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.contacts);
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<PermissionGroup, PermissionStatus> permissionStatus =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.contacts]);
      return permissionStatus[PermissionGroup.contacts] ??
          PermissionStatus.unknown;
    } else {
      return permission;
    }
  }
}
