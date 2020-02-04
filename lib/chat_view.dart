// Show chat
// 1. fix top scrolling
// 2. allow send coin
// 3. allow send message without subscription. how?
// 4. do not popup chat notification

import 'helpers/constants.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:upubsub_mobile/models/Subscription.dart';
import 'BitcoinOfThings_feed.dart';
import 'components/localStorage.dart';
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
    avatar: "https://cdn1.iconfinder.com/data/icons/user-pictures/100/supportfemale-512.png",
  );

  // the current user, loaded from local storage
  ChatUser _me; 

  List<ChatMessage> messages = List<ChatMessage>();
  var m = List<ChatMessage>();

  Subscription _sub;

  var i = 0;

  @override
  void initState() {
    super.initState();
  }

  Future<void> getUser() async {
    var currentuser = await LocalStorage.getJSON(Constants.KEY_USER);

    if (currentuser == null) {
      this._me = new ChatUser(name: "unknown");
    } else {
    this._me = new ChatUser(
      name: currentuser["name"], 
      uid: currentuser["moneyButtonId"] );
    }

    //subscribe to group/support
    this._sub = Subscription.fromJSON(
      {
      'pub': {
        'id': "5e37502b1c4a1f4103af6305", 
        'name': "PubSub Customer Support", 
        'topic': "group/support" }, 
        'username': "5e1b8dd805a33f28cbdfdad1", 
        'clientId': "5e3750cd1c4a1f4103af6306", 
        'status': "active", 'expires': "2020-03-02T22:44:25.625Z"
        }
      );
    this._sub.pubsub = new PubSubConnection(this._sub);
    this._sub.enabled = true;
    await this._sub.subscribe();
    onSend(new ChatMessage(text:"Welcome to Pub\$ub support channel.", 
      user: this._me));

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Pub\$ub Support Chat"),
      ),
      body: 
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
      stream: BitcoinOfThingsMux.stream,
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
            showUserAvatar: false,
            showAvatarForEveryMessage: false,
            scrollToBottom: false,
            onPressAvatar: (ChatUser user) {
              // todo pop up menu
              print("OnPressAvatar: ${user.name}");
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
                    ChatMessage image = new ChatMessage(text: null, user: _me, 
                      image: await result.readAsString());
                    onSend(image);                      
                  }
                },
              )
            ],
          );
        }
      });
    }
}
