import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:hane/test_views/indication_box.dart';
import 'package:hane/test_views/overview_box.dart';

class TestTab extends StatelessWidget {
 @override
  Widget build(BuildContext context) {
   


     return Scaffold(
        appBar: AppBar(

          title: Text('Adrenalin'),
          
        ),
        body: 
        
        
        Column(
          children: [
            overviewBox(),
            indicationTab(),
            Expanded(child: indicationBox()) //bottom box should extend down.
            
          ],
        ),
      );
  }
}






class indicationTab extends StatelessWidget {
  const indicationTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DefaultTabController(
    
        length: 8,
        child: Container(
          height: 30,
          child: TabBar(
            unselectedLabelStyle: TextStyle(color: Color.fromARGB(255, 157, 157, 157)),
            labelColor: Colors.black,
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
            Tab(text: 'Hjärtstopp',),
            Tab(text: 'Tab 3',),
            Tab(text: 'Tab 4',),
            Tab(text: 'tab5'),
            Tab(text: "kadwojspovniocevoina"),
            Tab(text: "kadwojspovniocevoina"),
            Tab(text: "kadwojspovniocevoina"),
          
          
          ],),
        ),
      )
    );
  }
}

