import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "dart:convert"as convert;
import 'Config.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();

}
TextEditingController email = TextEditingController();
TextEditingController name = TextEditingController();
TextEditingController pass = TextEditingController();

Future addAccount()async{


  var result = await http.post(Uri.parse('${Config.baseURL}/addrecord.php'),
    body: convert.jsonEncode(<String, String>{
      'email':email.text,
      'name' :name.text,
      'pass' :pass.text,
    })
  );
  var res = result.body;

  print("$res");
}

class _SignupState extends State<Signup> {
  @override
  //Custom_Widgets
  Widget input_textField(var txt1,var txt2,TextEditingController input){
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
  Widget button(var txt){
    return ElevatedButton(
      child: Text(txt,style: TextStyle(fontSize: 20,fontFamily: 'cursive'),),
      onPressed: () => {
        addAccount(),
        email.text="",
        name.text="",
        pass.text="",
      Navigator.pop(context)},
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

@override
Widget build(BuildContext context) {
  //final width = MediaQuery.of(context).size.width * 1;
  //final height = MediaQuery.of(context).size.height * 0.4;
  return Scaffold(
    body: SingleChildScrollView(
      child: Column(
        children: [
      Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Container(
        child: Center(child: Text("Signup",
            style: TextStyle(color: Colors.deepOrangeAccent,
                fontSize: 50,fontWeight:
                FontWeight.bold,
                fontFamily: 'cursive'))),
        padding: const EdgeInsets.all(4),
      ),
    ),
          Center(
            child: Image.asset(
              "images/img1.png",
              height: 120,
            ),
          ),
          input_textField('  EMAIL','EMAIL',email),
          input_textField('  NAME','NAME',name),
          input_textField('  Password', 'Password',pass),
          button('SIGNUP'),
          button('SIGNIN')

        ],
      ),
    ),
  );
}

}

