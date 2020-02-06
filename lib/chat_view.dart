// Show chat
// 1. fix scrolling, in general
// 2. allow send coin
// 3. allow send message without subscription. how?
// ============================
//import 'package:upubsub_mobile/app_events.dart';

import 'package:http/http.dart' as http;
//import 'helpers/constants.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'chat/dash_chat.dart';
import 'package:upubsub_mobile/models/Subscription.dart';
import 'main.dart';
import 'mqtt_stream.dart';

// display chat in a page
class ChatView extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<ChatView> {
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();

  // bot injects some auto generated messages into stream
  ChatUser _bot = ChatUser(
    name: "Chat Bot",
    uid: "0123",
    avatar: 
    "https://amphenol-antennas.com/wp-content/uploads/2017/05/Customer-Support-Icon-300x300.jpg"
    //"https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTiTK6pMtIb5hAtMBd93Fr_XIbYmzvl9n-4h6tq0HooGqvQjWST"
    //"https://cdn1.iconfinder.com/data/icons/user-pictures/100/supportfemale-512.png",
  );

  // the current user, loaded from local storage
  ChatUser _me; 

  List<ChatMessage> messages = List<ChatMessage>();
  var m = List<ChatMessage>();

  Subscription _sub;

  var i = 0;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    Bus.subscribe((msg) {
      //print(msg);
      //set _me based on info passed
      if (msg.topic == "chatuser") {
        // this._me = new ChatUser(
        //   name: currentuser["name"], 
        //   uid: currentuser["moneyButtonId"] );
        // }
        this.setState(() => this._me = new ChatUser(
          name: msg.payload["name"],
          uid: msg?.payload["moneyButtonId"] == null
            ? '' : msg?.payload["moneyButtonId"],
          avatar: msg?.payload["avatar"] == null
            ? '' : msg?.payload["avatar"],
          password: msg?.payload["pass"] == null
            ? '' : msg?.payload["pass"]
          )
        );
      }
    });
  }

  // todo, _me will come in when user specified
  Future<void> getUser() async {
    if (_me == null) return;
    // call api to get sub, create sub if anon
    // subscribe to group/support
    this._sub = await _getSubscription(this._me);
    if (this._sub != null) {
      this._sub.setSingleplexStream();
      this._sub.pubsub = new PubSubConnection(this._sub);
      this._sub.enabled = true;
      var welcome;
      try {
        await this._sub.subscribe();
        welcome = ChatMessage(
          text:"Hello ${this._me.name}! Welcome to Pub\$ub support chat. Ask your support question here and someone should be available shortly to answer.", 
          user: this._bot);
      }
      catch (ex) {
        // ${ex.toString()}.
        welcome = ChatMessage(
          text:"Hello ${this._me.name}! ${ex.toString()}. There was an error. Chat is not available. Contact support at http://upubsub.com", 
          user: this._bot);
      }
      _sub.stream.add(
        StreamMessage(
          _sub.topic,
          jsonEncode(welcome.toJson())
      ));
    }
  }

  void systemMessage() {
    Timer(Duration(milliseconds: 300), () {
      if (i < 6) {
        setState(() {
          messages = [...messages, m[i]];
        });
        i++;
      }
      Timer(Duration(milliseconds: 300), () {
        _chatViewKey.currentState.scrollController
          ..animateTo(
            _chatViewKey.currentState.scrollController.position.maxScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
      });
    });
  }

  // send a chat message == publish
  void onSend(ChatMessage message) {
    var jmess = message.toJson();
    //publish on customer service topic
    this._sub.publish(jsonEncode(jmess));
  }

  Widget waiting() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return this._me == null 
    ? waiting()
    : Container(
          child:
          FutureBuilder<void>(
        future: getUser(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _chatStream();
          } else {
            return waiting();
          }
        }
      )
    );
  }

  Widget _chatStream() {
  return
    StreamBuilder(
      stream: _sub.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return waiting();
        } else {
          print(snapshot);
          final streammessage = snapshot.data;
          ChatMessage message;
          if (streammessage.object != null) {
            try {
              message = ChatMessage.fromJson(streammessage.object);
            }
            catch (err) {
              message = new ChatMessage(text: streammessage.rawString, 
              user: _bot);
            }
          } else {
              message = new ChatMessage(text: streammessage.rawString, 
              user: _bot);
          }
          messages.add(message);
          // var messages =
          //     items.map((i) => ChatMessage.fromJson(i.data)).toList();
          return DashChat(
            key: _chatViewKey,
            inverted: false,
            onSend: onSend,
            user: _me,
            inputDecoration:
                InputDecoration.collapsed(hintText: "Add message here..."),
            dateFormat: DateFormat('yyyy-MMM-dd'),
            timeFormat: DateFormat('HH:mm'),
            messages: messages,
            showUserAvatar: true,
            showAvatarForEveryMessage: false,
            scrollToBottom: true,
            onPressAvatar: (ChatUser user) {
              // todo pop up menu
              print("OnPressAvatar: ${user.name}");
                showDialog(
                  context: context,
                  builder: (BuildContext context) => 
                    _buildAvatarDialog(user),
              );
            },
            onLongPressAvatar: (ChatUser user) {
              print("OnLongPressAvatar: ${user.name}");
            },
            inputMaxLines: 5,
            messageContainerPadding: EdgeInsets.only(left: 5.0, right: 5.0),
            alwaysShowSend: true,
            inputTextStyle: TextStyle(fontSize: 16.0),
            inputContainerStyle: BoxDecoration(
              border: Border.all(width: 0.0),
              color: Colors.white,
            ),
            onQuickReply: (Reply reply) {
              setState(() {
                messages.add(ChatMessage(
                  text: reply.value,
                  createdAt: DateTime.now(),
                  user: _me));

                messages = [...messages];
              });

              Timer(Duration(milliseconds: 300), () {
                _chatViewKey.currentState.scrollController
                  ..animateTo(
                    _chatViewKey.currentState.scrollController.position
                        .maxScrollExtent,
                    curve: Curves.easeOut,
                    duration: const Duration(milliseconds: 300),
                  );

                if (i == 0) {
                  systemMessage();
                  Timer(Duration(milliseconds: 600), () {
                    systemMessage();
                  });
                } else {
                  systemMessage();
                }
              });
            },
            onLoadEarlier: () {
              print("loading...");
            },
            shouldShowLoadEarlier: false,
            showTraillingBeforeSend: true,
            trailing: <Widget>[
              IconButton(
                icon: Icon(Icons.photo),
                onPressed: () async {
                  File result = await ImagePicker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 80,
                    maxHeight: 400,
                    maxWidth: 400,
                  );
                  if (result != null) {
                    // when user selected an image... 
                    var bytes = await result.readAsBytes();
                    // set text as empty string, null produces exception
                    ChatMessage image = new ChatMessage(text: '', user: _me, 
                      image: base64Encode(bytes));
                    onSend(image);                      
                  }
                },
              )
            ],
          );
        }
      });
  }

  Widget _buildAvatarDialog(ChatUser user) {
    return new AlertDialog(
      title: Text(user.name),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Something good coming...'),
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

  Future<Subscription> _getSubscription(ChatUser user) async {

    // auth is either user/pwd from localstorage
    // or chatuser.username
    var auth = {"p":user.name, "u": user.password};

    var response = await http.post(
        "https://api.bitcoinofthings.com/getchat",
        body: jsonEncode(auth),
        headers: {HttpHeaders.contentTypeHeader: "application/json"},
        );
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var data = jsonResponse;
        if (data != null ) {
          var sub = Subscription.fromJSON(data);
          return sub;
        } else {
          print('Not Authorized!');
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    return null;

    // return Subscription.fromJSON(
    //   {
    //   'pub': {
    //     'id': "5e37502b1c4a1f4103af6305", 
    //     'name': "PubSub Customer Support", 
    //     'topic': "group/support" }, 
    //     'username': "5e1b8dd805a33f28cbdfdad1", 
    //     'clientId': "5e3750cd1c4a1f4103af6306", 
    //     'status': "active", 'expires': "2020-03-02T22:44:25.625Z"
    //     }
    //   );
  }


}
