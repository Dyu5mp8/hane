import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class TestTab extends StatelessWidget {
 @override
  Widget build(BuildContext context) {
    
     return Scaffold(
        appBar: AppBar(
          title: Text('Custom Tabs Example'),
          
        ),
        body: 
        
        Center(
          child: DefaultTabController(

            length: 8,
            child: Container(
              height: 30,
              child: TabBar(
                tabAlignment: TabAlignment.start,
                indicatorSize: TabBarIndicatorSize.tab,
                isScrollable: true,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.lightBlue, 
                  border: Border.all(color: Colors.black, width: 0.4)
                  
                        
              
                  
                ),
                
                tabs: [
                      
                Tab(text: 'Anafylaxi'),
                Tab(text: 'Tab 2',),
                Tab(text: 'Tab 3',),
                Tab(text: 'Tab 4',),
                Tab(text: 'tab5'),
                Tab(text: "kadwojspovniocevoina"),
                Tab(text: "kadwojspovniocevoina"),
                Tab(text: "kadwojspovniocevoina"),
              
              
              ],),
            ),
          )
        ),
      );
  }
}

