// workflow for entering chat
// 1. if user logged in then let then through
// 2. if not then open dialog prompt for a name
// 3. call api to get or create chat sub
// 4. pass subscription to chat

import 'package:flutter/material.dart';
import 'components/serviceDialog.dart';

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

  _ChatWorkflowState(this._dialogService);

  Future promptUserName() async {
    var dialogResult = await _dialogService.showDialog();
    print (dialogResult);
  }

  start() async {
    // get currently logged in user
    // prompt for name if needed
    await promptUserName();
    return "something";
  }

  @override
  void initState() {
    super.initState();
    _dialogService.registerDialogListener(_showDialog);
  }

  @override
  build (context) {
    // //future builder here?
    // start().then((res) {
    //   print(res);
    // });
    return widget.child;
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => 
          _buildDialog(),
    );
  }
  
  _buildDialog() {
    // UI dialog for getting user name
      AlertDialog(
        title: Text('Enter a user name'),
        content: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Get username here...'),
          ],
        ),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            textColor: Theme.of(context).primaryColor,
            child: const Text('Close'),
          ),
        ],
      );
    }
}

