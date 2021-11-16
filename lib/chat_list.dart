import 'dart:ui';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:chat_app/Config.dart';
import 'package:chat_app/chat_screen.dart';
import 'package:flutter/material.dart';
var id;
class ChatList extends StatefulWidget {
 ChatList(var userid) {
    id = userid;
  }

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  List<dynamic> lst = [];

  Future getChatList() async {

    var url = Uri.parse("${Config.baseURL}/account_list.php");
    // var response = await http.get(url);
    var response = await http.post(url, body: {"id": id,});
    // print("::::::${response.body}");
    if(response.statusCode==200){
      var data = convert.jsonDecode(response.body);
      for(var row in data['result']){
        setState(() {
          lst.add(row);
        });
      }
      //print('${data['result']}');
    }
    else{
      print("error");
    }

  }



  //custom widgets
  Widget image_icon(){
    return   Padding(
      padding: EdgeInsets.only(top: 15.0, left: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[

          //user image
          CircleAvatar(radius: 30,backgroundColor: Colors.white,),
          Container(
              width: 100.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  //sreach icon
                  IconButton(
                    icon: Icon(Icons.search),
                    color: Colors.white,
                    onPressed: () {},
                  ),

                  //setting icon
                  IconButton(
                    icon: Icon(Icons.settings),
                    color: Colors.white,
                    onPressed: () {},
                  )
                ],
              ))
        ],
      ),
    );
  }
  Widget text(var txt){
    return  Padding(
      padding: EdgeInsets.only(left: 40.0),
      child: Row(
        children: <Widget>[
          Text(txt,
              style: TextStyle(
                fontFamily: 'cursive',
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 35.0,)),
        ],
      ),
    );
  }
  Widget listview_builder(){
    return Container(
      height: MediaQuery.of(context).size.height - 185.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)),
      ),
      child:  Padding(
          padding: EdgeInsets.only(top: 45.0,left: 22),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child:ListView.builder(
              itemCount:lst.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Container(
                    height: 60,
                    child: Card(
                      child: Text(lst[index]['name']),
                    ),
                  ),
                  onTap : (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatScreen(lst[index]['name'],lst[index]['id'],id)),
                    );
                  }
                );
              },
            ),)),

    );
  }
  @override
  void initState() {
    getChatList();
  }
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.deepOrangeAccent,
      body: ListView(
        children: <Widget>[
          image_icon(),
          SizedBox(height: 25.0),
          text('Chat List'),
          SizedBox(height: 30.0),
          listview_builder()

        ],
      ),
    );

  }


}
