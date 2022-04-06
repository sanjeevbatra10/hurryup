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
import 'dart:html' as html;
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
  //late String myurl;
  String para1 = "";
  late String url;
  late Widget _iframeWidget;
  //Random random = new Random();  
  PayTMState({required this.orderdata});

  final randomnbr = new Random();
  late PymtResponse  responsedata;
  String paymentstatus = "In progress";
  CustSession session = ICustSession;
 String merchantid = "";
 //late HtmlElementView htmlelementview; 
 html.IFrameElement? element = html.IFrameElement();

  
  String status = "";

  @override
  void dispose() {
    super.dispose();
    //element = null;
    
  }

Future<CustSession> getUser() async {

      //print("paytm payment web : ");
      SharedPreferences preferences = await SharedPreferences.getInstance();
      merchantid = preferences.getString("merchantid")??"";
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


// Future<bool> urlChanged(String url) async {
//         showDialog(
//                                     context: context,
//                                     builder: (context) => AlertDialog(
//                                           elevation: 24.0,
//                                           backgroundColor: Config.theme[colorscheme]!.listbgcolor1,
//                                           title: Text(Config.title,
//                                               style: TextStyle(
//                                                   letterSpacing: 2,
//                                                   fontFamily:
//                                                       Config.hdrfontfamily,
//                                                   fontSize:  (
//                                                       Config.size_medium),
//                                                   color: Colors.black54)),
//                                           content: Text(
//                                               "Window Changed " + url,
//                                               style: TextStyle(
//                                                   fontSize:  (
//                                                       Config.size_medium),
//                                                   color: Colors.black54)),
//                                           actions: <Widget>[
//                                             FlatButton(
//                                               color: Config.theme[colorscheme]!.iconcolor1,
//                                               child: Text(
//                                                 "Yes",
//                                                 style: TextStyle(
//                                                     fontSize:  
//                                                          (
//                                                             Config.size_small),
//                                                     color: Colors.black54),
//                                               ),
//                                               onPressed: () =>
//                                                  exit(0)
//                                             ),
//                                             FlatButton(
//                                               color: Config.theme[colorscheme]!.iconcolor1,
//                                               child: Text(
//                                                 "No",
//                                                 style: TextStyle(
//                                                     fontSize:  
//                                                          (
//                                                             Config.size_small),
//                                                     color: Colors.black54),
//                                               ),
//                                               onPressed: () {Navigator.pop(context);}
//                                             ),
//                                           ],
//                                         ));
//                                         return true;
//   }


// Future<bool> showMessage(String texttoDisplay) async {
//         showDialog(
//                                     context: context,
//                                     builder: (context) => AlertDialog(
//                                           elevation: 24.0,
//                                           backgroundColor: Config.theme[colorscheme]!.listbgcolor1,
//                                           title: Text(Config.title ,
//                                               style: TextStyle(
//                                                   letterSpacing: 2,
//                                                   fontFamily:
//                                                       Config.hdrfontfamily,
//                                                   fontSize:  (
//                                                       Config.size_medium),
//                                                   color: Colors.black54)),
//                                           content: Text(
//                                               texttoDisplay,
//                                               style: TextStyle(
//                                                   fontSize:  (
//                                                       Config.size_medium),
//                                                   color: Colors.black54)),
//                                           actions: <Widget>[
//                                             FlatButton(
//                                               color: Config.theme[colorscheme]!.iconcolor1,
//                                               child: Text(
//                                                 "Yes",
//                                                 style: TextStyle(
//                                                     fontSize:  
//                                                          (
//                                                             Config.size_small),
//                                                     color: Colors.black54),
//                                               ),
//                                               onPressed: () =>
//                                                  exit(0)
//                                             ),
                                            
//                                           ],
//                                         ));
//                                         return true;
//   }


  _init() {

    var orderidrandom =
    // randomnbr.nextInt(10000).toString() + orderdata['ordernumber'];
      orderdata['ordernumber'];
    var customerid = orderdata['customerid'];
    var amount = orderdata['amount'];
    var email = orderdata['email'];
    var merchantid = orderdata['merchantid'];
    var phonenumber = orderdata['phone'];
    var currencysymbol = MyPrjUtil.currencySymbol(session.businesscurrency);
    final queryParams =
        "?order_id=$orderidrandom&customer_id=$customerid&amount=$amount&email=$email&merchantid=$merchantid&phonenumber=$phonenumber&currencysymbol=$currencysymbol";
   url = Config.paytmApiUrl + queryParams;
   
   //print("paytm payment web :  build 2" + url);
    
   if (para1 == "callback")
    {
          url = "https://hurryupstores.com";
    }


    print("create IFRAME Element");

    //int rnumber = random.nextInt(2000);
    element = html.IFrameElement()
      ..src = url
      ..id = 'iFrame' 
      ..style.border = 'none';
      
    //register view factory
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'iframeElement',
      (int viewId) {        
        
        
      //   html.window.document.addEventListener("eventname", (event) {
      //       //MyToastMessages.popupToast("Event Received in callback: ${"received from IFRAM"}", 12, "green");
      //       //showMessage("Display Capture from IFRAME 1");

      //   });
        
      //   //html.window.document
      //   html.window.onMessage.listen((element) {
      //   //MyToastMessages.popupToast("Event Received in callback:", 12, "green");
      //   //showMessage("Display Capture from IFRAME 2");
      // });


        return element!;
      }
    );


  print("create IFRAME Element _iframeWidget" );
      
   _iframeWidget = HtmlElementView(
      key: UniqueKey(),
      viewType: 'iframeElement',
      
   );     
  
  }

  


  @override
  void initState() {
    super.initState();
    //print("paytm payment web :  initState");
    
    getColorScheme();
 
    
    getUser();    

    _init();
    
    // html.window.document.getElementById('iFrame')!.parent!.addEventListener("eventname", (event) {
    //         //MyToastMessages.popupToast("Event Received in callback: ${"received from IFRAM"}", 12, "green");
    //         showMessage("Display Capture window document");

    //     });

    // html.window.document.addEventListener("eventname", (event) {
    //         //MyToastMessages.popupToast("Event Received in callback: ${"received from IFRAM"}", 12, "green");
    //         setState(() {
    //           status = "html.window.document.addEventListener";
    //         });
    //         //showMessage("Display Capture window document");

    //     });


    // html.window.document.addEventListener("eventname", (event) {
    //         //MyToastMessages.popupToast("Event Received in callback: ${"received from IFRAM"}", 12, "green");
    //         //showMessage("Display Capture window document");
    //         setState(() {
    //           status = "html.window.document.addEventListener";
    //         });
    //     });

    // html.window.addEventListener("eventname", (event) {
    //         //MyToastMessages.popupToast("Event Received in callback: ${"received from IFRAM"}", 12, "green");
    //         setState(() {
    //           status = "html.window.addEventListener";
    //         });
    //         //showMessage("Display Capture from Flutter 1");

    //     });
    // html.window.onMessage.listen((event) {
    //     var data = event.data;
    //     showMessage(" From Outside Captured - Flutter");
    //     setState(() {
    //           status = "html.window.onMessage";
    //         });
    // });
  
  
  
  }


//   void setupViewForWeb(String url){
//     //print("paytm payment web :  setupViewForWeb");
//     element.referrerPolicy = "unsafe-url";
//     //register view factory
//     // ignore: undefined_prefixed_name
//     ui.platformViewRegistry.registerViewFactory("iframeElement", (int viewId) {
      
    
//       //window.addEventListener();
//       window.addEventListener( 'urlchanged', (event) {
//         //urlChanged("URL CHanged");
// 	    // The URL changed...

//       });


//       //window.addEventListener();
//       window.addEventListener( 'click', (event) {
//         //urlChanged("Clicked");
// 	    // The URL changed...

//       });

//      // window.location.href =
//       //window.cookieStore.getAll()      
      // window.onMessage.listen((element) {

  
      //   //MyToastMessages.popupToast("messsage received", 12, "green");
      //   MyToastMessages.popupToast("Event Received in callback: ${element.data}", 12, "green");

      // });
      
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
//      });

//       element.requestFullscreen();
//       element.
//       //element.src = "https://hurryupstores.com/paytmpay";
//       print("url in setview" + url);
//       element.src = url;
//       element.allowPaymentRequest = true;
      
      
// //      element.src = "abc.html";
//       ////print("element.sandbox.value");
//       ////print (element.sandbox.value); 
//       //element.src = "abc.html";
//       element.style.border = 'none';
//       return element;
//     });
//     // Add wait before opening the payment page
//   }

  

  
  Future<bool> _onBackPressed() {

   //html.window.document.
   Navigator.pop(context, responsedata == null ? PymtResponse(status: "Failed", respcode: "00", respmsg: "Payment Failed", txndate: "", txnid: "9999999", invoicenbr: '999999999'): responsedata );
   return Future.value(true);

  }

  @override
  Widget build(BuildContext context) {
    
    //MyPrjUtil.initScreenUtil(context);
    //print("paytm payment web :  build");
    

      
      //setupViewForWeb("https://hurryupstores.com/");
   // }

// for clear text erro add android:usesCleartextTraffic="true" in C:\srcode\fluttersamples\paytmtesting\android\app\src\main\AndroidManifest.xml
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Config.theme[colorscheme]!.hdrbgcolor1,
          title: Text(Config.title + "" + status),
          leading: IconButton(
                icon: Icon(Icons.arrow_back),
                iconSize:  (Config.size_large),
                onPressed: () {
                  _onBackPressed();
                },
        )),
        body: _iframeWidget,
        );
  }
}
