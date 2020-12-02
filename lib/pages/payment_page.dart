import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cardNumberTextFieldController = TextEditingController();
    final expiryDateTextFieldController = TextEditingController();
    final cVCTextFieldController = TextEditingController();
    final holdersNameTextFieldController = TextEditingController();
    double _fontSize = 16.0;
    double _radius = 5;
    double _radiusInner = 2.5;
    double _padX = 15;
    double _padY = 20;
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Colors.grey[350],
              child: Padding(
                padding: EdgeInsets.fromLTRB(_padX, _padY, _padX, _padY),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        child: Row(
                      children: [
                        CircleAvatar(
                          radius: _radius,
                          backgroundColor: Colors.blue,
                          child: CircleAvatar(
                            radius: _radiusInner,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        SizedBox(width: 15),
                        Text(
                          "Credit Card",
                          style: TextStyle(
                            fontSize: _fontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )),
                    Container(child:Row(children: [
                      Container(
                        padding: EdgeInsets.all(2),
                        constraints: BoxConstraints(maxWidth: 60),
                        child: Image.asset("assets/visa.png"),
                      ),
                      Container(
                        padding: EdgeInsets.all(2),
                        constraints: BoxConstraints(maxWidth: 60),
                        child: Image.asset("assets/mastercard.png"),
                      ),
                    ],))
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(width: 18),
                  CircleAvatar(
                    radius: _radius,
                    backgroundColor: Colors.blue,
                    child: CircleAvatar(
                      radius: _radiusInner,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Card Number",
                    style: TextStyle(
                      fontSize: _fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: cardNumberTextFieldController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  // fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  hintText: "1234 1234 1234 1234",
                  hintStyle: TextStyle(fontSize: _fontSize),
                  contentPadding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 20,
                    bottom: 20,
                  ),
                  suffixIcon: Icon(
                    Icons.credit_card,
                    size: 40,
                    color: Colors.black,
                  ),
                ),
                textAlign: TextAlign.justify,
              ),
            ),

            /* Expiry Date and CVC */

            Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 20),
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 18),
                            CircleAvatar(
                              radius: _radius,
                              backgroundColor: Colors.blue,
                              child: CircleAvatar(
                                radius: _radiusInner,
                                backgroundColor: Colors.white,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Expiry Date",
                              style: TextStyle(
                                fontSize: _fontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                          child: TextField(
                            controller: expiryDateTextFieldController,
                            // keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              hintText: "MM/YY",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 18),
                            CircleAvatar(
                              radius: _radius,
                              backgroundColor: Colors.blue,
                              child: CircleAvatar(
                                radius: _radiusInner,
                                backgroundColor: Colors.white,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "CVC",
                              style: TextStyle(
                                fontSize: _fontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                          child: TextField(
                            controller: cVCTextFieldController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              hintText: "CVC",
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            /* Card Holder Name */

            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                children: <Widget>[
                  SizedBox(width: 18),
                  CircleAvatar(
                    radius: _radius,
                    backgroundColor: Colors.blue,
                    child: CircleAvatar(
                      radius: _radiusInner,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Card holder's name",
                    style: TextStyle(
                      fontSize: _fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: holdersNameTextFieldController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "Your Full Name",
                  // fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),

            /*Proceed Button */
            Padding(
              padding: const EdgeInsets.only(top: 80, left: 65),
              child: RaisedButton(
                padding: const EdgeInsets.symmetric(
                  horizontal: 100,
                  vertical: 16,
                ),
                color: Colors.blue,
                textColor: Colors.white,
                child: Text(
                  "Proceed",
                  style: TextStyle(
                    fontSize: _fontSize,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
                onPressed: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
