import 'package:flutter/material.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'dart:io';

enum BoostPlan { basic, pro, light }

class BoostAd extends StatefulWidget {
  @override
  _BoostAdState createState() => new _BoostAdState();
}

class _BoostAdState extends State<BoostAd> {
  Token _paymentToken;
  PaymentMethod _paymentMethod;

  ScrollController _controller = ScrollController();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  BoostPlan _boostPlan = BoostPlan.basic;

  @override
  initState() {
    super.initState();

    StripePayment.setOptions(
      StripeOptions(
        publishableKey:
            "pk_test_51HhDhlGHgpLgqT0UfnizHwrWf8931NgXIt57gzf3i7PoayfiagrLIYH6xY5YSiSC3ti26LSP2HPClQwZKeqNxv4U00IuIkPJBu",
        merchantId: "Test",
        androidPayMode: 'test',
      ),
    );
  }

  void setError(dynamic error) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          "Ooops. An Error Occurred!",
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
    setState(() {
      print(error.toString());
    });
  }

  Widget getHeading(String str) {
    return Stack(
      children: <Widget>[
        //border.
        Text(
          str,
          style: TextStyle(
            fontSize: 30,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2
              ..color = Colors.blue,
          ),
        ),
        // Solid text.
        Text(
          str,
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget getExpiry(var x) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Expires: ",
            style: TextStyle(color: Colors.blue,
              fontSize: 12,
            ),
          ),
          Text(
            x.toString() + " days",
            style: TextStyle(
              color: Colors.white,
              fontStyle: FontStyle.italic,
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }

  Widget getDesc(String str, bool check) {
    return Expanded(
      child: Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                check ? Icons.check : Icons.clear,
                color: check ? Colors.blue : Colors.red,
                size: 12,
              ),
              Padding(padding: const EdgeInsets.fromLTRB(7, 0, 0, 0),child: Text(
                str,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),),
            ],
          )),
    );
  }

  Widget getPrice(var price) {
    return Expanded(
      child: Text(
        "Rs." + price.toString(),
        style: TextStyle(
            color: Colors.blue,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: "Monospace"),
      ),
    );
  }

  Widget getRadio(BoostPlan value) {
    return Container(
      child: Radio(
        value: value,
        groupValue: _boostPlan,
        onChanged: (BoostPlan value) {
          setState(() {
            _boostPlan = value;
          });
        },
      ),
      height: 15,
      width: 15,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget verticalGap(double height) {
    return Container(
      height: height,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Boost Your Ad'),
        leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView(
        controller: _controller,
        padding: const EdgeInsets.all(10),
        children: <Widget>[
          verticalGap(20),
          Container(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        getHeading("Light"),
                        verticalGap(30.0),
                        getDesc("Top of search\nlist", true),
                        getDesc("Featured ad\nlist", false),
                        getExpiry(5),
                        verticalGap(30.0),
                        getPrice(100),
                        getRadio(BoostPlan.light),
                      ],
                    ),),
                    // VerticalDivider(
                    //   color: Colors.white,
                    //   thickness: 1.0,
                    //   width: 1,
                    // ),
            Expanded(child:Column(
                      children: [
                        getHeading("Basic"),
                        verticalGap(30.0),
                        getDesc("Top of search\nlist", true),
                        getDesc("Featured ad\nlist", false),
                        getExpiry(10),
                        verticalGap(30.0),
                        getPrice(200),
                        getRadio(BoostPlan.basic),
                      ],
                    ),),
                    // VerticalDivider(
                    //   color: Colors.white,
                    //   thickness: 1.0,
                    //   width: 1,
                    // ),
            Expanded(child:Column(
                      children: [
                        getHeading("Pro"),
                        verticalGap(30.0),
                        getDesc("Top of search\nlist", true),
                        getDesc("Featured ad\nlist", true),
                        getExpiry(5),
                        verticalGap(30.0),
                        getPrice(400),
                        getRadio(BoostPlan.pro),
                      ],
                    ),),
                  ],
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                ),
              ],
            ),
          ),
          verticalGap(10),
          Divider(
            thickness: 2.0,
          ),
          verticalGap(20),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Colors.blue,
              child: Text(
                "Pay via Card",
                style: TextStyle(color: Colors.white, fontFamily: "Monospace"),
              ),
              onPressed: () {
                StripePayment.paymentRequestWithCardForm(
                        CardFormPaymentRequest())
                    .then((paymentMethod) {
                  _scaffoldKey.currentState.showSnackBar(
                    SnackBar(
                      content: Text(
                        'Payment completed with ' +
                            paymentMethod.card.brand +
                            " " +
                            "************" +
                            paymentMethod.card.last4,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  );
                  setState(() {
                    _paymentMethod = paymentMethod;
                  });
                }).catchError(setError);
              },
            ),
          ),
          Container(
            child: Text(
              "or",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Colors.blue,
              child: Text(
                "Pay via GPay/Apple Pay",
                style: TextStyle(color: Colors.white, fontFamily: "Monospace"),
              ),
              onPressed: () {
                if (Platform.isIOS) {
                  _controller.jumpTo(450);
                }
                StripePayment.paymentRequestWithNativePay(
                  androidPayOptions: AndroidPayPaymentRequest(
                      totalPrice: "1",
                      currencyCode: "EUR",
                      lineItems: [
                        LineItem(currencyCode: 'EUR', description: "Ad Boost")
                      ]),
                  applePayOptions: ApplePayPaymentOptions(
                    countryCode: 'DE',
                    currencyCode: 'EUR',
                    items: [
                      ApplePayItem(
                        label: 'Ad Boost',
                        amount: '1',
                      )
                    ],
                  ),
                ).then((token) {
                  setState(() {
                    _paymentToken = token;
                    StripePayment.completeNativePayRequest().then((_) {
                      _scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                          content: Text(
                            'Payment completed with ' +
                                _paymentMethod.card.brand +
                                " " +
                                "************" +
                                _paymentMethod.card.last4,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      );
                    }).catchError(setError);
                  });
                }).catchError(setError);
              },
            ),
          ),
        ],
      ),
    );
  }
}
