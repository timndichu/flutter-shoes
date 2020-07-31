import 'package:coolkicks/enum/connectivity_status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckConnection extends StatelessWidget {

  final Widget ewidget;

  CheckConnection({this.ewidget});


  @override
  Widget build(BuildContext context) {
      Widget renderedWidget;
      var connectionStatus = Provider.of<ConnectivityStatus>(context);

    if(connectionStatus == ConnectivityStatus.WiFi || connectionStatus == ConnectivityStatus.Cellular) {
       renderedWidget = ewidget;
       
    }
   

    if (connectionStatus == ConnectivityStatus.Offline) {
      renderedWidget = Center(child: CircularProgressIndicator());
    
    }

    return renderedWidget;

  }
}