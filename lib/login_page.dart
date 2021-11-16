import 'dart:convert';
import 'package:chat_app/chat_list.dart';
import "package:flutter/material.dart";
import 'Config.dart';
import 'sign_up.dart';
import 'package:http/http.dart'as http;
import 'dart:convert' as convert;

class Login extends StatefulWidget {
  //const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}
TextEditingController email = TextEditingController();
TextEditingController pass = TextEditingController();

class _LoginState extends State<Login> {

  //Custom_Widgets
  Widget input_textField(var txt1,var txt2 , TextEditingController input){
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        elevation: 30,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: TextField(
          controller: input,
          decoration: InputDecoration(
            //enabledBorder: InputBorder.none,
            //disabledBorder: InputBorder.none,
            labelText: txt1,
              hintText: txt2,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                  borderSide: new BorderSide(
                      color: Colors.black
                  )
              ),),
          ),
      ),
    );

  }
  Widget button(var txt ){
    return ElevatedButton(
      child: Text(txt,style: TextStyle(fontSize: 20,fontFamily: 'cursive'),),
      onPressed: () => {
        getRecord(),
        email.text='',
        pass.text="",
     },
      style: ElevatedButton.styleFrom(
        primary: Colors.deepOrangeAccent,
        onPrimary: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        elevation: 20
      ),
    );
  }
  Widget text(var txt ,Color clr){
    return  Center(
        child: Container(
              child: Text(txt,style: TextStyle(fontSize: 23,fontFamily: 'cursive',color: clr),)),
         );

  }
  Widget text1(var txt ,Color clr, var fun){
    return  Center(
      child: GestureDetector(
        child: Container(
            child: Text(txt,style: TextStyle(fontSize: 23,fontFamily: 'cursive',color: clr),)),
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => fun),
          );
        },
      ),

    );

  }
  Widget card(IconData icon){
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      child:  Icon(icon, color: Colors.deepOrangeAccent, size: 50.0,),
    );
  }

 var id;

  Future getRecord() async {

    var url = Uri.parse("${Config.baseURL}/fetchrecord.php");
    var response = await http.post(url, body: {"email": email.text, "pass": pass.text});

    print("::::::${response.body}");
    if(response.statusCode==200){
      setState((){

        var data = jsonDecode(response.body);
       print('${data['result']['id']}');
       id = data['result']['id'];

       Navigator.push(
         context,
         MaterialPageRoute(builder: (context) => ChatList(id)),
       );
      });

    }
    else{
      print("error");
    }

  }
  @override
  Widget build(BuildContext context) {
   // final width = MediaQuery.of(context).size.width * 1;
    //final height = MediaQuery.of(context).size.height * 0.4;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
        Padding(
          padding: const EdgeInsets.only(top: 140),
          child: Container(
            child: Center(child: Text("Login",
                style: TextStyle(color: Colors.deepOrangeAccent,
                    fontSize: 50,fontWeight:
                    FontWeight.bold,
                    fontFamily: 'cursive'))),
            padding: const EdgeInsets.all(4),
           ),
        ),
            text('Acccess Acount',Colors.black),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                card(Icons.facebook),
                card(Icons.email),
              ],
            ),
            text('or Login with Email',Colors.black),
            input_textField('   EMAIL','EMAIL',email),
            input_textField('   PASSWORD','PASSWORD',pass),
            button('SIGNIN'),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               text('Dont have an account?',Colors.black),
                text1('Register',Colors.deepOrangeAccent,Signup()),
              ],
            )
        ],
        ),
      ),
    );
  }
}
