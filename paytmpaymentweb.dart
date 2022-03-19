import 'dart:async';
import 'dart:math';
import 'dart:io';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mink/config/config.dart';
import 'package:mink/models/pymtresponse.dart';
import 'package:mink/utils/myproject_utils.dart';
import 'dart:ui' as ui;
import 'dart:html';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:mink/models/session.dart';
import 'package:mink/widgets/toast_message.dart';
import 'package:mink/widgets/loadingwidget.dart';



class PayTMPaymentWeb extends StatefulWidget {
  final Map<String, String> orderdata;
  PayTMPaymentWeb({required this.orderdata});

  PayTMState createState() => PayTMState(orderdata: orderdata);
}

class PayTMState extends State<PayTMPaymentWeb> {
  final Map<String, String> orderdata;
  String colorscheme = "green";
  late String myurl;
  String para1 = "";
  late String url;
  PayTMState({required this.orderdata});

  final randomnbr = new Random();
  late PymtResponse  responsedata;
  String paymentstatus = "In progress";
  CustSession session = ICustSession;
 String merchantid = "";
 //late HtmlElementView htmlelementview; 
 IFrameElement element = IFrameElement();

  
  String status = "";

  @override
  void dispose() {
    super.dispose();
  }

Future<CustSession> getUser() async {

      //print("paytm payment web : ");
      SharedPreferences preferences = await SharedPreferences.getInstance();
      merchantid = preferences.getString("merchantid")!;
    // //print("pmerchantid :" + merchantid);
      var pjson = preferences.getString(merchantid);
      if (pjson != "null") {
      var pmap = json.decode(pjson!);
          //setState(() {
              ////print("getting user details xxx" + merchantid);
              
      //print("Menu Page :" + pjson);

      session = CustSession.fromJson(pmap);
      return session;

        /// });
      }

      return session;
  }

  void getColorScheme() async {
    var scheme = await  MyPrjUtil.getMerchantTheme();
    //print("paytm payment web :  getColorScheme");
      
    //print(scheme);
    if ( scheme != null)
    {
       //print(scheme);
      setState(() {
        colorscheme = scheme;
      });
    }
  }


Future<bool> urlChanged(String url) async {
        showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          elevation: 24.0,
                                          backgroundColor: Config.theme[colorscheme]!.listbgcolor1,
                                          title: Text(Config.title,
                                              style: TextStyle(
                                                  letterSpacing: 2,
                                                  fontFamily:
                                                      Config.hdrfontfamily,
                                                  fontSize:  (
                                                      Config.size_medium),
                                                  color: Colors.black54)),
                                          content: Text(
                                              "Window Changed " + url,
                                              style: TextStyle(
                                                  fontSize:  (
                                                      Config.size_medium),
                                                  color: Colors.black54)),
                                          actions: <Widget>[
                                            FlatButton(
                                              color: Config.theme[colorscheme]!.iconcolor1,
                                              child: Text(
                                                "Yes",
                                                style: TextStyle(
                                                    fontSize:  
                                                         (
                                                            Config.size_small),
                                                    color: Colors.black54),
                                              ),
                                              onPressed: () =>
                                                 exit(0)
                                            ),
                                            FlatButton(
                                              color: Config.theme[colorscheme]!.iconcolor1,
                                              child: Text(
                                                "No",
                                                style: TextStyle(
                                                    fontSize:  
                                                         (
                                                            Config.size_small),
                                                    color: Colors.black54),
                                              ),
                                              onPressed: () {Navigator.pop(context);}
                                            ),
                                          ],
                                        ));
                                        return true;
  }



  @override
  void initState() {
    super.initState();
    //print("paytm payment web :  initState");
    
    if (kIsWeb)
    {
      myurl = Uri.base.toString(); //get complete url
      //print(myurl);
      
    
      // if (para1 == "callback")
      // {
      //   url = "https://hurryupstores.com";
      // }
    }
    //String para2 = Uri.base.queryParameters["para2"];
    //print("paytm payment web :  initState 2");
    
    getColorScheme();
 
    //print("paytm payment web :  initState 2-1");
   
    getUser();    

    //print("paytm payment web :  initState 3");
    
  }

  void setupViewForWeb(String url){
    //print("paytm payment web :  setupViewForWeb");
    
    //register view factory
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory("abc-html", (int viewId) {
      
      //window.addEventListener();
      window.addEventListener( 'urlchanged', (event) {
        //urlChanged("URL CHanged");
	    // The URL changed...

      });


      //window.addEventListener();
      window.addEventListener( 'click', (event) {
        //urlChanged("Clicked");
	    // The URL changed...

      });

     // window.location.href =
      
      window.onMessage.listen((element) {
        
        //MyToastMessages.popupToast("messsage received", 12, "green");
        MyToastMessages.popupToast("Event Received in callback: ${element.data}", 12, "green");
        
        //  if (jsonresponse["razorpay_payment_id"] == "ERROR")
        // {
        //   responsedata = new PymtResponse(status: "Failed", respcode: "00", respmsg: "Payment Failed", txndate: "", txnid: "9999999");
        //   setState(() {
        //     paymentstatus = "Payment Failed";
        //   });
        // }
        // else
        // {
        //   responsedata = new PymtResponse(status: "Successful", respcode: "01", respmsg: "Payment Approved", txndate: "", txnid: jsonresponse["razorpay_payment_id"]);
        //   setState(() {
        //    paymentstatus = "Payment Successful - " + jsonresponse["razorpay_payment_id"];
        // });

        // if(element.data=='CUSTOMER_CANCELLED' && paymentstatus != "Payment Cancelled"){
        //   responsedata = new PymtResponse(status: "Failed", respcode: "00", respmsg: "Payment Failed", txndate: "", txnid: "9999999");
        //   setState(() {
        //     paymentstatus = "Payment Cancelled";
        //   });
        // }else {
        //   if (element.data !='CUSTOMER_CANCELLED')
        //   {
        //     var jsonresponse = jsonDecode(element.data);
        //     responsedata = new PymtResponse(status: "Successful", respcode: "01", respmsg: "Payment Approved", txndate: "", txnid: jsonresponse["razorpay_payment_id"]);
        //     setState(() {
        //       paymentstatus = "Payment Successful - " + jsonresponse["razorpay_payment_id"];
        //       //paymentstatus = element.data;
        //     });
        //   }
            
        // }
      });

      element.requestFullscreen();
      //element.src = "https://hurryupstores.com/paytmpay";
      print("url in setview" + url);
      element.src = url;
      
//      element.src = "abc.html";
      ////print("element.sandbox.value");
      ////print (element.sandbox.value); 
      //element.src = "abc.html";
      element.style.border = 'none';
      return element;
    });
    // Add wait before opening the payment page
  }

  Future<bool> _onBackPressed() {

   Navigator.pop(context, responsedata == null ? PymtResponse(status: "Failed", respcode: "00", respmsg: "Payment Failed", txndate: "", txnid: "9999999"): responsedata );
   return Future.value(true);

  }

  @override
  Widget build(BuildContext context) {
    
    //MyPrjUtil.initScreenUtil(context);
    //print("paytm payment web :  build");
    
    var orderidrandom =
        // randomnbr.nextInt(10000).toString() + orderdata['ordernumber'];
         orderdata['ordernumber'];
    var customerid = orderdata['customerid'];
    var amount = orderdata['amount'];
    var email = orderdata['email'];
    var merchantid = orderdata['merchantid'];
    var phonenumber = orderdata['phone'];

    final queryParams =
        "?order_id=$orderidrandom&customer_id=$customerid&amount=$amount&email=$email&merchantid=$merchantid&phonenumber=$phonenumber";
   url = Config.paytmApiUrl + queryParams;
   
   //print("paytm payment web :  build 2" + url);
    
   if (para1 == "callback")
      {
        url = "https://hurryupstores.com";
    }
   
   if (kIsWeb)
    {  
      print(url);
      setupViewForWeb(url); 
      
      //setupViewForWeb("https://hurryupstores.com/");
    }

// for clear text erro add android:usesCleartextTraffic="true" in C:\srcode\fluttersamples\paytmtesting\android\app\src\main\AndroidManifest.xml
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Config.theme[colorscheme]!.hdrbgcolor1,
          title: Text(Config.title),
          leading: IconButton(
                icon: Icon(Icons.arrow_back),
                iconSize:  (Config.size_large),
                onPressed: () {
                  _onBackPressed();
                },
        )),
        body: kIsWeb && paymentstatus == "In progress" ? SizedBox( height: 500, width: 500, child: HtmlElementView(key: UniqueKey(), viewType: 'abc-html')) : (Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  session.shopimage != '' ? CircleAvatar(
                    backgroundColor: Config.theme[colorscheme]!.hdrbgcolor1,
                    radius: 80,
                    backgroundImage: NetworkImage('${Config.WEBAPP_HOST_PROFILE}/${session.merchantid}/${session.shopimage}'),
                    ): CircleAvatar(
                    backgroundColor: Config.theme[colorscheme]!.hdrbgcolor1,
                    radius: 80,
                    child: Image.asset('assets/images/' + Config.logo_white),                    
                  ),
                Padding(
                          padding: EdgeInsets.only(top: 10.0),
                        ),
                Text(
                  paymentstatus, //Config.title,
                  style: TextStyle(
                      color: Colors.black87,
                      //fontWeight: FontWeight.bold,
                      fontFamily: Config.hdrfontfamily,
                      fontSize:  (Config.size_medium)),
                ),
                Padding(
                          padding: EdgeInsets.only(top: 10.0),
                ),
                paymentstatus == "In progress" ? 
                CustomLoading(option: "Circle")
                :
                ElevatedButton(onPressed: _onBackPressed, 
                style: ElevatedButton.styleFrom(
                primary:  Config.theme[colorscheme]!.hdrbgcolor1,
                ),
                child: Text(
                  "Go Back To Order Summary", //Config.title,
                  style: TextStyle(
                      color: Config.theme[colorscheme]!.txtcolor1,
                      //background: Config.theme[colorscheme]!.hdrbgcolor1,
                      //backgroundColor: Config.theme[colorscheme]!.hdrbgcolor1,
                      //fontWeight: FontWeight.bold,
                      fontFamily: Config.hdrfontfamily,
                      fontSize:  (Config.size_medium)),
                ),)

              ]))),
      );
  }
}
