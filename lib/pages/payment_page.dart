import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cardNumberTextFieldController = TextEditingController();
    final expiryDateTextFieldController = TextEditingController();
    final cVCTextFieldController = TextEditingController();
    final holdersNameTextFieldController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {},
        ),
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
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(width: 15),
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.purple,
                      child: CircleAvatar(
                        radius: 5,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 15),
                    Text(
                      "Credit Card (Stripe)",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 50),
                    Container(
                      padding: EdgeInsets.all(2),
                      constraints: BoxConstraints(maxWidth: 60),
                      child: Image.asset("assets//visa.png"),
                    ),
                    Container(
                      padding: EdgeInsets.all(2),
                      constraints: BoxConstraints(maxWidth: 60),
                      child: Image.asset("assets//mastercard.png"),
                    ),
                    SizedBox(width: 15),
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
                    radius: 10,
                    backgroundColor: Colors.orange,
                    child: CircleAvatar(
                      radius: 5,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Card Number",
                    style: TextStyle(
                      fontSize: 20.0,
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
                  hintStyle: TextStyle(fontSize: 18),
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
                              radius: 10,
                              backgroundColor: Colors.orange,
                              child: CircleAvatar(
                                radius: 5,
                                backgroundColor: Colors.white,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Expiry Date",
                              style: TextStyle(
                                fontSize: 20.0,
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
                            textAlign: TextAlign.center,
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
                              radius: 10,
                              backgroundColor: Colors.orange,
                              child: CircleAvatar(
                                radius: 5,
                                backgroundColor: Colors.white,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "CVC",
                              style: TextStyle(
                                fontSize: 20.0,
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
                            textAlign: TextAlign.center,
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
                    radius: 10,
                    backgroundColor: Colors.orange,
                    child: CircleAvatar(
                      radius: 5,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Card holder's name",
                    style: TextStyle(
                      fontSize: 20.0,
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
                    fontSize: 16.0,
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
