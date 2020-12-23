import 'package:flutter/material.dart';
import 'package:flutter_login_demo/data/ad_data.dart';
import 'package:flutter_login_demo/pages/upload_images.dart';
import 'package:flutter_login_demo/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class AdPost extends StatefulWidget {
  AdPost({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => _AdPostState();
}

class _AdPostState extends State<AdPost> {
  AdData data=AdData(uid:"",title:"",desc:"",category:"",province:"",city:"",price:0,duration:"",address:"");

  static const List<String> _lendDuration = ['Per Day','Per Week','Per Month'];
  String _selectedDuration;

  List<String> _province = ['Sindh', 'Balouchistan', 'KPK', 'Punjab'];
  List<String> _sindhCities = [
    'Karachi',
    'Hyderabad',
    'Sukkur',
  ];
  List<String> _punjabCities = [
    'Islamabad',
    'Rawalpindi',
    'Lahore',
  ];
  List<String> _kpkCities = [
    'Peshawar',
    'Abbotabad',
    'Mardan',
  ];
  List<String> _balouchCities = [
    'Gawadar',
    'Sui',
    'Quetta',
  ];

  String _selectedProvince;
  String _selectedCity;

  List<String> _categories;
  String _selectedCategory;

  bool isUploading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    data.uid=widget.userId;
    _getCategories();
  }

  void _getCategories() {
    print("db get categories started");
    final dbRef = Firestore.instance.collection("app_data");
    dbRef.document("categories").get().then(
      (value) {
        if (value.data.containsKey('cat')) {
          value.data.forEach((key, value) {
            if (key == 'cat') {
              setState(() {
                _categories = value.cast<String>();
              });
            }
          });
        }
      },
    );
    print("db data get finished");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(child:Scaffold(
      appBar: AppBar(
        title: Text("Post New Ad"),
      ),
      body: Container(
//        decoration: BoxDecoration(
//          image: DecorationImage(
//            image: AssetImage("assets/background.png"),
//            fit: BoxFit.cover,
//          ),
//        ),
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              _showTitleInput(),
              _showDescInput(),
              _showPriceInput(),
              _showDurationDropDown(),
              _categories == null
                  ? _showCircularProgress()
                  : _showCategoryDropDown(),
              _showAddressInput(),
              _showLocationDropDown(),
              _showButtons(),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
              ),
            ],
          ),
        ),
      ),
    ),onTap: ()=>{FocusScope.of(context).unfocus()},);
  }

  Widget _showCircularProgress() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _showTitleInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        autofocus: false,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(),
          ),
          hintText: 'Title',
          contentPadding: EdgeInsets.fromLTRB(30, 0, 0, 0),
          icon: Icon(Icons.title),
        ),
        validator: (value) => value.isEmpty ? 'Title can\'t be empty' : null,
        onSaved: (value) => data.title=value,
      ),
    );
  }

  Widget _showDescInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 5,
        autofocus: false,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(),
          ),
          hintText: 'Description',
          contentPadding: EdgeInsets.fromLTRB(30, 30, 0, 0),
          icon: Icon(Icons.description),
        ),
        //textAlign: TextAlign,
        validator: (value) => value.isEmpty ? 'Description can\'t be empty' : null,
        onSaved: (value) => data.desc=value,
      ),
      // ),
    );
  }

  Widget _showPriceInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      child: TextFormField(
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly
        ],
        maxLines: 1,
        keyboardType: TextInputType.number,
        autofocus: false,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(),
          ),
          hintText: 'Price',
          contentPadding: EdgeInsets.fromLTRB(30, 0, 0, 0),
          icon: Icon(Icons.attach_money),
        ),
        validator: (value) => value.isEmpty ? 'Price can\'t be empty' : null,
        onSaved: (value) => data.price=double.parse(value),
      ),
    );
  }

  Widget _showAddressInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 2,
        autofocus: false,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(),
          ),
          hintText: 'Address',
          contentPadding: EdgeInsets.fromLTRB(30, 30, 0, 0),
          icon: Icon(Icons.description),
        ),
        //textAlign: TextAlign,
        validator: (value) => value.isEmpty ? 'Address can\'t be empty' : null,
        onSaved: (value) => data.address=value,
      ),
      // ),
    );
  }

  Widget _showLocationDropDown() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      child: Container(
        child: Column(
          children: <Widget>[
            _getProvinceDropDown(),
            _selectedProvince == null ? Container() : _getCityDropDown(),
          ],
        ),
      ),
    );
  }

  Widget _showButtons() {
    return Padding(
      padding: EdgeInsets.fromLTRB(30.0, 20, 30.0, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _showDismissButton(),
         Container(width:30),
          _showNextButton(),
        ],
      ),
    );
  }

  Widget _showDismissButton() {
    return Expanded(
      child: SizedBox(
        height: 40.0,
        width: 150.0,
        child: RaisedButton(
          elevation: 5.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          color: Colors.grey,
          child: Text(
            "Dismiss",
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
          onPressed: Navigator.of(context).pop,
        ),
      ),
    );
  }

  Widget _showNextButton() {
    return Expanded(
      child: SizedBox(
        height: 40.0,
        width: 150.0,
        child: RaisedButton(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.blue,
          child: Text(
            "Next",
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
          onPressed: validateAndSubmit,
        ),
      ),
    );
  }

  void validateAndSubmit() {
    FocusScope.of(context).unfocus();
    if (validateAndSave()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UploadImages(
            data: data,
            userId: widget.userId,
            auth: widget.auth,
            logoutCallback: widget.logoutCallback,
          ),
        ),
      );
    }
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      print(data.title);
      return true;
    }
    return false;
  }

  Widget _showCategoryDropDown() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Row(
        children: <Widget>[
          Icon(Icons.category, color: Colors.grey),
          Container(
            width: 17.0,
          ),
          Expanded(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                hint: Text('Please Select A Category'),
                onTap: ()=>{FocusScope.of(context).unfocus()},
                value: _selectedCategory,
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    child: Text(category),
                    value: category,
                  );
                }).toList(),
                validator: (value) =>
                    value == null ? 'Please Select A Category' : null,
                onSaved: (value) => data.category=value,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _showDurationDropDown() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Row(
        children: <Widget>[
          Icon(Icons.timer, color: Colors.grey),
          Container(
            width: 17.0,
          ),
          Expanded(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                hint: Text('Please Select Lend Duration'),
                value: _selectedDuration,
                onTap: ()=>{FocusScope.of(context).unfocus()},
                onChanged: (newValue) {
                  setState(() {
                    _selectedDuration = newValue;
                  });
                },
                items: _lendDuration.map((duration) {
                  return DropdownMenuItem(
                    child: Text(duration),
                    value: duration,
                  );
                }).toList(),
                validator: (value) =>
                value == null ? 'Please Select The Lend Duration' : null,
                onSaved: (value) => data.duration=value,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getCityDropDown() {
    return Column(
      children: <Widget>[
        Container(
          height: 20,
        ),
        Row(
          children: <Widget>[
            Icon(Icons.location_city, color: Colors.grey),
            Container(
              width: 17.0,
            ),
            Expanded(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.grey))),
                  hint: Text('Please Choose Your City'),
                  value: _selectedCity,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCity = newValue;
                    });
                  },
                  items: _getCities().map((location) {
                    return DropdownMenuItem(
                      child: Text(location),
                      value: location,
                    );
                  }).toList(),
                  validator: (value) =>
                      value == null ? 'Price Select A City' : null,
                  onSaved: (value) => data.city=value,
                  onTap: ()=>{FocusScope.of(context).unfocus()},
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<String> _getCities() {
    switch (_selectedProvince) {
      case ("Sindh"):
        return _sindhCities;

      case ("Punjab"):
        return _punjabCities;

      case ("Balouchistan"):
        return _balouchCities;

      case ("KPK"):
        return _kpkCities;
    }
    List<String> deflt = ['Please Select Province'];
    return deflt;
  }

  Widget _getProvinceDropDown() {
    return Row(
      children: <Widget>[
        Icon(Icons.map, color: Colors.grey),
        Container(
          width: 17.0,
        ),
        Expanded(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButtonFormField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              onTap: ()=>{FocusScope.of(context).unfocus()},
              hint: Text('Please Choose Your Province'),
              value: _selectedProvince,
              onChanged: (newValue) {
                setState(() {
                  _selectedProvince = newValue;
                  _selectedCity = null;
                });
              },
              items: _province.map((province) {
                return DropdownMenuItem(
                  child: Text(province),
                  value: province,
                );
              }).toList(),
              validator: (value) =>
                  value == null ? 'Please Select A Province' : null,
              onSaved: (value) => data.province=value,
            ),
          ),
        ),
      ],
    );
  }
}
