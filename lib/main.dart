import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
        primaryColor: Colors.indigo,
        primarySwatch: Colors.indigo,
        accentColor: Colors.indigoAccent,
        brightness: Brightness.dark),
    title: "Simple Interest Calculator App",
    debugShowCheckedModeBanner: false,
    home: SIForm(),
  ));
}

class SIForm extends StatefulWidget {
  const SIForm({Key? key}) : super(key: key);

  @override
  State<SIForm> createState() => _SIFormState();
}

class _SIFormState extends State<SIForm> {
  var _formKey = GlobalKey<FormState>();
  var _currencies = ['Rupees', 'Doller', 'Pound', 'Reyal', 'Other'];
  final _minimumPadding = 4.0;
  var _currentItemSelected = '';
  var _displayResult = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentItemSelected = _currencies[0];
  }

  TextEditingController principalControler = TextEditingController();
  TextEditingController roiControler = TextEditingController();
  TextEditingController termControler = TextEditingController();
  @override
  Widget build(BuildContext context) {
    //TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      //resizeToAvoidBottomInset: false,  // this works but for some time not for all the devices
      appBar: AppBar(title: Text("Simple Interest Calculator")),
      body: Form(
        key: _formKey,
        child: (Padding(
          padding: EdgeInsets.all(_minimumPadding * 2),
          //margin:
          child: ListView(
            children: [
              getImageAsset(),
              Padding(
                padding: EdgeInsets.only(
                    top: _minimumPadding, bottom: _minimumPadding),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: principalControler,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "please enter principal amount";
                    }
                  },
                  decoration: InputDecoration(
                      labelText: ("Principal"),
                      hintText: ("Enter Principal e.g 12000"),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      errorStyle:
                          TextStyle(color: Colors.amber, fontSize: 14.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: _minimumPadding, bottom: _minimumPadding),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  controller: roiControler,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "please enter rate of interest";
                    }
                  },
                  decoration: InputDecoration(
                      labelText: ("Rate of Interest"),
                      hintText: ("In Persentage"),
                      errorStyle:
                          TextStyle(fontSize: 14.0, color: Colors.amber),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: _minimumPadding, bottom: _minimumPadding),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: termControler,
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return "please enter time in Year";
                          }
                        },
                        decoration: InputDecoration(
                            labelText: ("Term"),
                            hintText: ("Time in year"),
                            errorStyle: TextStyle(
                              color: Colors.amber,
                              fontSize: 14.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            )),
                      ),
                    ),
                    Container(
                      width: _minimumPadding * 5,
                    ),
                    Expanded(
                      child: DropdownButton<String>(
                        items: _currencies.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        value: _currentItemSelected,
                        onChanged: (String? newValueSelected) {
                          _ondropDownItemSelectd(newValueSelected!);
                        },
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: _minimumPadding, bottom: _minimumPadding),
                child: Row(
                  children: [
                    Expanded(
                        child: RaisedButton(
                      color: Theme.of(context).accentColor,
                      textColor: Theme.of(context).primaryColorDark,
                      child: Text(
                        "Calculate", textScaleFactor: 1.5,
                        // style: TextStyle(
                        //     fontSize: 18.0, fontWeight: FontWeight.bold,
                        //     )
                      ),
                      onPressed: () {
                        setState(() {
                          if (_formKey.currentState!.validate()) {
                            this._displayResult = _calculateTotalReturns();
                          }
                        });
                      },
                    )),
                    Container(width: _minimumPadding),
                    Expanded(
                        child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        "Reset", textScaleFactor: 1.5,
                        // style: TextStyle(
                        //     fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        setState(() {
                          _reset();
                        });
                      },
                    )),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding, bottom: _minimumPadding),
                  child: Text(this._displayResult)),
            ],
          ),
        )),
      ),
    );
  }

  Widget getImageAsset() {
    AssetImage assetImage = AssetImage("Images/money.png");
    Image image = Image(
      image: assetImage,
      width: 100.0,
      height: 100.0,
    );
    return Container(
      child: image,
      margin: EdgeInsets.all(_minimumPadding * 8),
    );
  }

  void _ondropDownItemSelectd(String newvalueSelected) {
    setState(() {
      this._currentItemSelected = newvalueSelected;
    });
  }

  String _calculateTotalReturns() {
    double principal = double.parse(principalControler.text);
    double roi = double.parse(roiControler.text);
    double term = double.parse(termControler.text);

    double totalAmoutPayable = principal + (principal * roi * term) / 100;
    String Result =
        'After $term years, your investment will be worth $totalAmoutPayable $_currentItemSelected';

    return Result;
  }

  void _reset() {
    principalControler.text = "";
    roiControler.text = "";
    termControler.text = "";
    _displayResult = "";
    _currentItemSelected = _currencies[0];
  }
}
