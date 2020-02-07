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
  // flag to remember if user was already published
  bool _waspublished = false;

  _ChatWorkflowState(this._dialogService);

  Future promptUserName() async {
    var dialogResult = await _dialogService.showDialog();
    return dialogResult;
  }

  Future<void> start() async {
    if (_waspublished) return;
    // get currently logged in api user, if any
    var usercred = await LocalStorage.getJSON(PubSubConstants.Constants.KEY_CRED);
    var username = usercred == null ? '' : usercred["username"] ?? '';
    var pass = usercred == null ? '' : usercred["pass"] ?? '';

    if (username == null || username.length < 1) {
      //there is no api user
      var chatuser = await LocalStorage.getJSON(PubSubConstants.Constants.KEY_CHATUSER);
      if (chatuser != null) {
        Bus.publish(PubSubConstants.Constants.KEY_CHATUSER, chatuser);
        this.setState(() => this._waspublished = true);
      } else {
        // there is no chat user saved locally
        await promptUserName();
        //user result will be null here! have to harvest in dialog.then
      }
    } else {
        Bus.publish(PubSubConstants.Constants.KEY_CHATUSER, 
          {"name":username, "pass": pass});
        this.setState(() => this._waspublished = true);
    }
  }

  @override
  void initState() {
    super.initState();
    _dialogService.registerDialogListener(_showDialog);
  }

  @override
  build (context) {
    // this will run user login check in the background
    // and possible prompt for user name
    WidgetsBinding.instance.addPostFrameCallback((_) 
      => _onAfterBuild(context));
    // at the same time show empty chat in background
    return widget.child;
  }

  void _onAfterBuild(BuildContext context){
    if (_waspublished == false) {
      start();
    }
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => 
          _buildDialog(),
    ).then ( (username) {
      if (username == null) return;
      // this returns the result of the dialog
      //this.setState(() {_username = username;});
      // just raise event and let chat view handle it
      var chatuser = { "name": username };
      LocalStorage.putJSON(PubSubConstants.Constants.KEY_CHATUSER,
        chatuser);
      Bus.publish(PubSubConstants.Constants.KEY_CHATUSER, chatuser);
      this.setState(() => this._waspublished = true);
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
              Navigator.of(context).pop();
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

