import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:chat_app/Config.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_2.dart';



class ChatScreen extends StatefulWidget {

  var name;
  var sndrid;
  var recid;
   ChatScreen(var username, var sid, var rid ){
    name = username;
    sndrid = sid;
    recid = rid;

  }

  @override
  _ChatScreenState createState() => _ChatScreenState();
}
class _ChatScreenState extends State<ChatScreen> {
  TextEditingController msg = TextEditingController();
  List<dynamic> mesg = <dynamic>[];
  String istying = "";
  String isTyping = "";

  SendMessage()async{


    var result = await http.post(Uri.parse('${Config.baseURL}/sendMessage.php'),
        body: convert.jsonEncode(<String, String>{
        'msg':msg.text,
        'senderid' : widget.sndrid,
         'receiverid' : widget.recid,

        })
    );
    var res = result.body;

    print("send msg:::$res");
  }
 getMessages()async{
   print(":::::::${widget.recid}");
   var url = Uri.parse("${Config.baseURL}/getMsgs.php");
    //var response = await http.get(url);
   var response = await http.post(url, body: {"senderid": widget.sndrid,"receiverid":widget.recid});

   print(response.body);
   if(response.statusCode==200){
     var data = jsonDecode(response.body);
     mesg.clear();

     for(var row in data['result']){
       setState(() {
         mesg.add(row);
       });
     }

   }
   else{
     print("error");
   }
 }

  SmsTyping() async {
   var response = await http.post(Uri.parse("${Config.baseURL}status.php"),
       body: {
      "senderid": widget.sndrid,
      "receiverid": widget.recid,
      "istyping": istying.length.toString()
    });
   var s = response.body;
   print("sender typing:::::::$s");
  }
  getReceiverTypingStatus() async {
   var response = await http.post(Uri.parse("${Config.baseURL}status.php"),
       body: {
      "senderid": widget.sndrid,
      "receiverid": widget.recid,
      "userTyping": "true"
    });

    if (response.statusCode == 200) {
      var type = jsonDecode(response.body);
      setStateIfMounted(() {
        isTyping = type['typing'];
      });

      print("receiver typing ${isTyping}");
    }
  }
  void setStateIfMounted(x) {
    if (mounted) setState(x);
  }



  initState() {
  super.initState();
  loadTimer();
  //getMessages();
 }

  loadTimer(){
    Timer.periodic(Duration(milliseconds: 1000),(timer){

      setState(() {
        getMessages();
        getReceiverTypingStatus();
        // Here you can write your code for open new view
      });
    });
  }

  getSenderView(var txt, CustomClipper clipper, BuildContext context) => ChatBubble(
    clipper: clipper,
    alignment: Alignment.topRight,
    margin: EdgeInsets.only(top: 20),
    backGroundColor: Colors.deepOrangeAccent,
    child: Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      child: Text( txt,
         style: TextStyle(color: Colors.black),
      ),
    ),
  );

  getReceiverView(var txt,CustomClipper clipper, BuildContext context) => ChatBubble(
    clipper: clipper,
    backGroundColor: Color(0xffE7E7ED),
    margin: EdgeInsets.only(top: 20),
    child: Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      child: Text(txt,style: TextStyle(color: Colors.black),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title:   Column(
          children: [
            Text(widget.name,  style: TextStyle(fontSize:23,color:Colors.black),),
            GestureDetector(
              child: Text(
                isTyping,
                style: TextStyle(
                    color: Colors.grey.shade600, fontSize: 13),
              ),
            ),
          ],
        ),
        //automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: <Widget>[
          ListView.builder(
            itemCount:mesg.length,
            itemBuilder: (context, index) {

              if(mesg[index]['senderid']==widget.sndrid && mesg[index]['receiverid']==widget.recid){
                return getSenderView(mesg[index]['msg'],
                    ChatBubbleClipper2(type: BubbleType.sendBubble),context);
              }
              else {

               return getReceiverView(mesg[index]['msg'],
                    ChatBubbleClipper2(type: BubbleType.receiverBubble), context);

              }


            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.deepOrangeAccent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(Icons.add, color: Colors.white, size: 20, ),
                    ),
                  ),
                  SizedBox(width: 15,),
                  Expanded(
                    child: TextField(
                      controller: msg,
                      onChanged: (v) {
                        setStateIfMounted(() {
                          istying = v;
                          // ignore: unnecessary_null_comparison
                        });
                        SmsTyping();
                      },
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none
                      ),
                    ),
                  ),
                  SizedBox(width: 15,),
                  FloatingActionButton(
                    onPressed: (){
                      SendMessage();
                      msg.text="";
  setStateIfMounted((){
    istying="";

  });
                    SmsTyping();

                    },
                    child: Icon(Icons.send,color: Colors.white,size: 18,),
                    backgroundColor: Colors.deepOrangeAccent,
                    elevation: 0,
                  ),
                ],

              ),
            ),
          ),
        ],
      ),

    );
  }
}
