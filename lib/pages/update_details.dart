import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

import 'package:flutter_login_demo/pages/home_page.dart';
import 'package:flutter_login_demo/services/authentication.dart';

class UpdateDetails extends StatefulWidget {
  UpdateDetails({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => _UpdateDetailsState();
}

class _UpdateDetailsState extends State<UpdateDetails> {
  final db = Firestore.instance;

  bool isUploading = false;

  var firstName = "";
  var lastName;
  var mNumber;
  var cnic;
  var dob;
  DateTime lastDate;

  final _formKey = GlobalKey<FormState>();
  final _minimumPadding = 5.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(AssetImage("assets/background.png"), context);
    });

    DateTime current = DateTime.now();
    lastDate = DateTime(current.year - 18, current.month - 1, current.day);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.center,
        child: Container(
          margin: EdgeInsets.all(_minimumPadding * 2),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              _showForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showForm() {
    return Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Center(
                child: Text(
                  "Update Details",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              firstNameInput(),
              lastNameInput(),
              dobInput(),
              cnicInput(),
              pNumberInput(),
              showSubmitButton(),
            ],
          ),
        ));
  }

  Widget firstNameInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        inputFormatters: [
          WhitelistingTextInputFormatter(RegExp("[a-zA-Z]")),
        ],
        textCapitalization: TextCapitalization.sentences,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: InputDecoration(
          labelText: 'First Name',
          hintText: 'First Name',
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'First name is required';
          } else {
            return null;
          }
        },
        onSaved: (value) => firstName = value,
      ),
    );
  }

  Widget lastNameInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        inputFormatters: [
          WhitelistingTextInputFormatter(RegExp("[a-zA-Z]")),
        ],
        textCapitalization: TextCapitalization.sentences,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: InputDecoration(
          labelText: "Last Name",
          hintText: 'Last Name',
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Last name is required';
          } else {
            return null;
          }
        },
        onSaved: (value) => lastName = value,
      ),
    );
  }

  Widget dobInput() {
    final format = DateFormat("dd-MM-yyyy");
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      child: DateTimeField(
        autofocus: false,
        decoration: InputDecoration(
          labelText: "DOB",
          hintText: 'Date Of Birth',
        ),
        format: format,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
            context: context,
            firstDate: DateTime(1920),
            initialDate: currentValue ?? lastDate,
            lastDate: lastDate,
          );
        },
        validator: (value) {
          if (value == null) {
            return 'Date of Birth is required';
          }
          return null;
        },
        onSaved: (value) => dob = value,
      ),
    );
  }

  Widget cnicInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly
        ],
        //maxLength: 13,
        keyboardType: TextInputType.number,
        autofocus: false,
        decoration: InputDecoration(
          labelText: 'CNIC Number',
          hintText: '13 Digit CNIC',
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'CNIC is required';
          } else if (value.length > 13 || value.length < 13) {
            return 'CNIC number must be 13 digits';
          }
          return null;
        },
        onSaved: (value) => cnic = value,
      ),
    );
  }

  Widget pNumberInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly
        ],
        keyboardType: TextInputType.number,
        autofocus: false,
        //maxLength: 11,
        decoration: InputDecoration(
          labelText: 'Mobile Number',
          hintText: '0XXXXXXXXXX',
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Mobile number is required';
          } else if (value.length > 11 || value.length < 11) {
            return 'Mobile number must be 11 digits';
          } else if (value[0] != '0') {
            return 'Mobile number must start with \'0\'';
          }
          return null;
        },
        onSaved: (value) => mNumber = value,
      ),
    );
  }

  Widget showSubmitButton() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: RaisedButton(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: Text("Submit",
                style: TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: isUploading ? null : validateAndSubmit,
          ),
        ));
  }

  void validateAndSubmit() {
    if (validateAndSave()) {
      uploadInfo();
    }
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Widget _dismissButton() {
    return SizedBox(
      width: 100,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.grey,
        child: Text(
          "Dismiss",
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
        onPressed: () {
          setState(() {
            isUploading = false;
          });
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _returnButton() {
    return SizedBox(
      width: 100,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.blue,
        child: Text(
          "Return",
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                userId: widget.userId,
                auth: widget.auth,
                logoutCallback: widget.logoutCallback,
              ),
            ),
            (Route<dynamic> route) => false,
          );
        },
      ),
    );
  }

  void showSuccessfulDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text("Success!"),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Center(
                  child: Text(
                    "Details saved successfully.",
                  ),
                ),
              ),
              Center(child: _returnButton()),
            ],
          ),
          shape: RoundedRectangleBorder(
              side: BorderSide.none, borderRadius: BorderRadius.circular(25.0)),
        );
      },
    );
  }

  void showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error!"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Center(
                  child: Text(
                    "Saving details timed out. Please try again",
                  ),
                ),
              ),
              Center(child: _dismissButton()),
            ],
          ),
          shape: RoundedRectangleBorder(
              side: BorderSide.none, borderRadius: BorderRadius.circular(25.0)),
        );
      },
    );
  }

  void uploadInfo() async {
    setState(() {
      isUploading = true;
      dob = dob.day.toString() +
          "-" +
          dob.month.toString() +
          "-" +
          dob.year.toString();
    });
    await db
        .collection("Users")
        .document(widget.userId)
        .setData(
          {
            'UID': widget.userId,
            'fName': firstName,
            'lName': lastName,
            'cnic': cnic,
            'mNumber': mNumber,
            'dob': dob.toString()
          },
        )
        .then(
          (doc) {
            print("Data Uploaded");
            showSuccessfulDialog();
          },
        )
        .timeout(Duration(seconds: 5))
        .catchError(
          (error) {
            showErrorDialog();
            print("Data upload error");
            print(error);
          },
        );
  }
}
