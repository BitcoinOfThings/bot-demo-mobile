// workflow for entering chat
// 1. if user logged in then let then through
// 2. if not then open dialog prompt for a name
// 3. call api to get or create chat sub
// 4. pass subscription to chat

import 'package:flutter/material.dart';
import 'components/localStorage.dart';
import 'components/serviceDialog.dart';
import 'helpers/constants.dart' as PubSubConstants;
import 'main.dart';

class ChatWorkflow extends StatefulWidget {
  final DialogService _dialogService = new DialogService();
  // this is where user navigates to after workflow
  final Widget child;

  ChatWorkflow({Key key, this.child}) : super(key: key);

  @override
  _ChatWorkflowState createState() => _ChatWorkflowState(_dialogService);

}

class _ChatWorkflowState extends State<ChatWorkflow> {
  DialogService _dialogService;
  TextEditingController _textFieldController = TextEditingController();
  String _username;
  String _password;

  _ChatWorkflowState(this._dialogService);

  Future promptUserName() async {
    var dialogResult = await _dialogService.showDialog();
    return dialogResult;
  }

  Future<void> start() async {
    if (this._username == null) {
      // get currently logged in user
      var usercred = await LocalStorage.getJSON(PubSubConstants.Constants.KEY_CRED);
      var username = usercred == null ? '' : usercred["username"] ?? '';
      _password = usercred == null ? '' : usercred["pass"] ?? '';

      if (username == null || username.length < 1) {
        // prompt for name if needed
        username = await promptUserName();
        // todo store in LocalStorage
      } else {
        Bus.publish('chatuser', {"name":username, "pass": _password});
      }
      // call api to get subscription
      //return username;
    }
  }

  @override
  void initState() {
    super.initState();
    _dialogService.registerDialogListener(_showDialog);
  }

  @override
  build (context) {
    // return FutureBuilder<void>(
    //   future: start(),
    //   builder: (BuildContext context, AsyncSnapshot snapshot) {
    //     if (snapshot.connectionState == ConnectionState.done) {
    //       return widget.child;
    //     } else {
    //       return new CircularProgressIndicator();
    //     }
    //   }
    // );

    WidgetsBinding.instance.addPostFrameCallback((_) 
      => _onAfterBuild(context));
    return widget.child;
  }

  void _onAfterBuild(BuildContext context){
    start();
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => 
          _buildDialog(),
    ).then ( (username) {
      // this returns the result of the dialog
      this.setState(() {_username = username;});
      // just raise event and let chat view handle it
      Bus.publish('chatuser', {"name":username, "pass": "pubsub"});
    });
  }
  
  _buildDialog() {
    // UI dialog for getting user name
      return AlertDialog(
        title: Text('Entering support chatroom'),
        content: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('To chat with support a name or alias is required'),
            TextFormField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "enter a name"),
              validator: _validateName,              
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
              _dialogService.dialogComplete();
              Navigator.of(context).pop(
                _textFieldController.text
              );
            },
            textColor: Theme.of(context).primaryColor,
            child: const Text('Ok'),
          ),
          new FlatButton(
            onPressed: () {
              _dialogService.dialogComplete();
              Navigator.of(context).pushNamed('/');
            },
            textColor: Theme.of(context).primaryColor,
            child: const Text('Cancel'),
          ),
        ],
      );
    }

  String _validateName(String value) {
    if (value.isEmpty)
      return 'Name is required. It can be anything';
    return null;
  }
}

