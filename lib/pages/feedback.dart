import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_demo/services/authentication.dart';
import 'package:intl/intl.dart';

class FeedbackForm extends StatefulWidget {
  FeedbackForm({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  TextEditingController _textController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  int _radioValue = 1;

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Feedback"),
        leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
      },
        child:SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: SafeArea(
          maintainBottomViewPadding: true,
          top: true,
          child: Container(
            width: screenSize.width,
            padding: EdgeInsets.symmetric(
              vertical: screenSize.height * 0.02,
              horizontal: screenSize.width * 0.01,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "We would love to hear your thoughts, suggestions, concerns or problems with anthing we can improve!",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Text(
                    "Feedback Type",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Radio(
                      value: 1,
                      onChanged: _handleRadioValueChange,
                      groupValue: _radioValue,
                    ),
                    Text("Comment"),
                    Radio(
                      value: 2,
                      onChanged: _handleRadioValueChange,
                      groupValue: _radioValue,
                    ),
                    Text("Suggestion"),
                    Radio(
                      value: 3,
                      onChanged: _handleRadioValueChange,
                      groupValue: _radioValue,
                    ),
                    Text("Question"),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "Describe Your Feedback: ",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      "*",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenSize.height * 0.01),
                Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Form(
                    key: _formKey,
                    child:TextFormField(
                      controller: _textController,
                      maxLines: 6,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                      ),
                      validator: (value) => value.trim().isEmpty ? 'Feedback can not be empty' : null,
                    )),),
                SizedBox(height: 10,),
                Divider(height: screenSize.height * 0.05,color: Colors.black,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.15,
                          vertical: screenSize.height * 0.016),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: Text(
                        "Clear",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.grey,
                      onPressed: () {
                          _textController.clear();
                      },
                    ),
                    RaisedButton(
                      color: Colors.blue,
                      padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.15,
                          vertical: screenSize.height * 0.016),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "Send",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        validateAndSubmit();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ) ,)
    );
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    FocusScope.of(context).unfocus();
    if (validateAndSave()) {
      String _message = _textController.text;
      String _type = "";
      switch(_radioValue){
        case(1):
          _type = "comment";
          break;
        case(2):
          _type = "suggestion";
          break;
        case(3):
          _type = "question";
          break;
        default:
          _type="unidentified";
      }
      Firestore.instance.collection("feedback").document(widget.userId+"_"+DateTime.now().toString()).setData({
        'feedback':_message,
        'userId':widget.userId,
        'time':DateTime.now(),
        'type':_type
      }).then((value) {
      _textController.clear();
          print("feedback sent");
          Navigator.of(context).pop();
      });

    }
  }
}
