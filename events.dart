import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:shimmer/shimmer.dart';

void main() => runApp(MyApp());

List rendertags = <String>[];
Map eventlist={};
List renderevents=[];


List filterchips = <Widget>[
  filterChipWidget(chipName: 'tag1',IsSelected: false,),
  filterChipWidget(chipName: 'tag2',IsSelected: false,),
  filterChipWidget(chipName: 'tag3',IsSelected: false,),
  filterChipWidget(chipName: 'Fashion',IsSelected: false,),
  filterChipWidget(chipName: 'Miscelleaneous',IsSelected: false,),];


void getrenderevents()
{
  rendertags=[];
renderevents=[];
for (int i=0;i<filterchips.length;i++)
{
  if(filterchips[i].IsSelected)
    rendertags.add(filterchips[i].chipName);
}
if(eventlist!=null) {
  if (rendertags.length == 0)
    for (int i = 0; i < eventlist['data'].length; i++)
      renderevents.add(eventlist['data'][i]);
  else
    for (int i = 0; i < eventlist['data'].length; i++) {
      for (int j = 0; j < rendertags.length; j++)
        if (eventlist['data'][i]['tags'].contains(rendertags[j])) {
          renderevents.add(eventlist['data'][i]);
        }
    }
  renderevents = renderevents.toSet().toList();
}
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        accentColor: Colors.blue,
      ),
      home: Sample2(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Sample2 extends StatefulWidget {
  @override
  _Sample2State createState() => _Sample2State();
}

class _Sample2State extends State<Sample2> {
  bool done =false;
  Future<Map> fetchEvents() async {
    http.Response response = await http.get('https://api.myjson.com/bins/q1x5o');
    setState(() {
      done = true;
    });
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Material(
            child: CustomScrollView(
                slivers: [
                  SliverPersistentHeader(
                    floating: true,
                    delegate: MySliverAppBar(expandedHeight: 250),
                    pinned: true,
                  ),
                  SliverFillRemaining(
                      child: FutureBuilder(
                          future: fetchEvents(),
                          builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
                            Map content = snapshot.data;
                            eventlist = content;
                            getrenderevents();
                            return (eventlist!=null)?Center(
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                    ),
                                    child: ListView.builder(
                                        itemCount: renderevents.length,
                                        addRepaintBoundaries: true,
                                        primary: true,
                                        itemBuilder: (context,index){
                                          return GestureDetector(
                                              onTap:(){
                                                _newTaskModalBottomSheet(context,renderevents[index]);
                                              },
                                              child: Container(
                                                margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                                                decoration: BoxDecoration(
                                                    color: Color.fromRGBO(43, 42, 42, 0.8),
                                                    borderRadius:  BorderRadius.circular(20.0),
                                                    boxShadow: [BoxShadow(
                                                      color: Colors.black,
                                                      blurRadius: 5.0,
                                                    ),]
                                                ),
                                                width: MediaQuery.of(context).size.width,
                                                height: 100.0,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: <Widget>[
                                                        Container(child: Text(renderevents[index]['name'],style: TextStyle(color: Colors.white,fontSize: 20),overflow: TextOverflow.ellipsis,),),
                                                        Container(child: Text(renderevents[index]['category'].toString(),style: TextStyle(color: Colors.white,fontSize: 16),))
                                                      ],
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.fromLTRB(0.0, 20.0,20.0, 20.0),
                                                      child: Icon(Icons.play_circle_outline,color: Colors.blue[500],),
                                                    ),
                                                  ],
                                                ),
                                              ));
                                        }
                                    )
                                )
                            ):Container(
                                decoration: BoxDecoration(
                                    color: Colors.black
                                ),
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                    child:Shimmer.fromColors(
                                        highlightColor: Colors.blue,
                                        baseColor: Colors.black,
                                        child: ImageIcon(AssetImage('Revelstemp.png'),size: 300.0,)
                                    )
                                )
                            );
                          }
                      )
                  )
                ]
            )
        )
    );
  }
}

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  MySliverAppBar({@required this.expandedHeight});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(43, 42, 42, 0.8),
        ),
        child: Stack(
          fit: StackFit.expand,
          overflow: Overflow.visible,
          children: [
            Container(
              decoration: BoxDecoration(gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromRGBO(1,89, 110, 1),
                  Color.fromRGBO(89,164,181, 0.8),
                  Color.fromRGBO(117,90,87, 0.7),
                  Color.fromRGBO(160,88,82, 0.8),
                  Color.fromRGBO(213,118,81, 0.7),
                  Color.fromRGBO(117,87,72, 0.8),
                ],
              ),),
            ),
            Center(
              child: Opacity(
                opacity: shrinkOffset / expandedHeight,
                child: Text(
                  "Events",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 23,
                  ),
                ),
              ),
            ),
            Opacity(
              opacity: (1 - shrinkOffset / expandedHeight),
              child: SizedBox(
                height: expandedHeight,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                        alignment: Alignment.center,
                        child: Wrap(
                          spacing: 5.0,
                          runSpacing: 3.0,
                          children: filterchips,
                        )),
                  ),
                ),
                // ),
              ),
              // ),
            ),
          ],
        ));
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
class filterChipWidget extends StatefulWidget {
  final String chipName;
  var IsSelected = false;
  filterChipWidget({Key key, this.chipName,this.IsSelected}) : super(key: key);

  @override
  _filterChipWidgetState createState() => _filterChipWidgetState();
}

class _filterChipWidgetState extends State<filterChipWidget> {

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      avatar: CircleAvatar(
          child: Container(
            child: Icon(Icons.blur_circular,),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.cyan,
            ),
          )),
      label: Text(widget.chipName),
      labelStyle: TextStyle(
        color: Colors.white,
        fontSize: 16.0,),
      selected: widget.IsSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      backgroundColor: Colors.black87,
      onSelected: (isSelected) {
        setState(() {
          widget.IsSelected = isSelected;
        });
        getrenderevents();
        },
      selectedColor: Colors.blue[600],
    );
  }
}

void _newTaskModalBottomSheet(context,event) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.65,
          child: Column(
            children: [
              Container(
                color: Colors.black,
                  height: 100.0,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 50.0,
                        child: Center(
                          child: Text(event['name'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.0)),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width*0.5,
                        child: Divider(
                          color: Colors.blue[500],
                          thickness: 3.0,
                        ),
                      ),
                      Container(
                        child: Text(event['category'].toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15.0)),
                      ),
                    ],
                  )),
              Container(
                height: MediaQuery.of(context).size.height * 0.65 - 100.0,
                child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return getDetails(context, index,event);
                  },
                  duration: 10,
                  itemCount: 2,
                  loop: false,
                  pagination: new SwiperPagination(),
                  control: new SwiperControl(),
                ),
              ),
            ],
          ),
        );
      });
}

Widget getDetails(context, i, event) {
  return i != 0
      ? Container(
    height: MediaQuery.of(context).size.height * 0.65 - 100.0,
    width: MediaQuery.of(context).size.width,
    color: Colors.black,
    child: Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 10.0,bottom: 10),
          child: Text(
            'Description:',
            style: TextStyle(color: Colors.white, fontSize: 30.0),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20.0),
          height: 200.0,
          width: MediaQuery.of(context).size.width / 1.2,
          child: Text(event['longDesc'],style: TextStyle(color: Colors.white, fontSize: 20.0),
              textAlign: TextAlign.center),
        )
      ],
    ),
  )
      : Container(
          height: MediaQuery.of(context).size.height * 0.65 - 100.0,
          width: MediaQuery.of(context).size.width,
          color: Colors.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 10.0, bottom:5.0),
          child: Text(
            event['delCardType'].toString(),
            style: TextStyle(color: Colors.white, fontSize: 30.0),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
            margin: const EdgeInsets.only(top: 10.0),
            height: 300.0,
            width: MediaQuery.of(context).size.width / 1.2,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(top: 10.0),
                      margin: const EdgeInsets.only(right: 20.0),
                      height: 100.0,
                      width: 100.0,
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.all(Radius.circular(10.0)),
                          border: Border.all(
                            width: 2.0,
                            color: Colors.blue[500],
                          )),
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: Text(
                              'Date',
                              style: headStyle(20.0),
                            ),
                          ),
                          Divider(
                            thickness: 2.0,
                            color: Colors.blue[500],
                            indent: 10.0,
                            endIndent: 10.0,
                          ),
                          Center(
                            child: Text('13/3', style: headStyle(30.0)),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10.0),
                      margin: const EdgeInsets.only(left: 20.0),
                      height: 100.0,
                      width: 150.0,
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.all(Radius.circular(10.0)),
                          border: Border.all(
                            width: 2.0,
                            color: Colors.blue[500],
                          )),
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: Text(
                              'Time',
                              style: headStyle(20.0),
                            ),
                          ),
                          Divider(
                            thickness: 2.0,
                            color: Colors.blue[500],
                            indent: 10.0,
                            endIndent: 10.0,
                          ),
                          Center(
                            child:
                            Text('00:00:00', style: headStyle(30.0)),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(top: 25.0, bottom:25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        child:
                        Text('Team Size: ', style: headStyle(20.0)),
                      ),
                      Stack(
                        children: <Widget>[
                          Container(
                              height: 30.0,
                              width: 30.0,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blue[500]),
                                  shape: BoxShape.circle,
                                  color: Colors.blue[500])),
                          Container(
                              height: 30.0,
                              width: 30.0,
                              child: Center(
                                child: Text(event['minTeamSize'].toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold)),
                              )),
                        ],
                      ),
                      Container(
                        width: 30.0,
                        height: 5.0,
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(5.0)),
                            shape: BoxShape.rectangle,
                            color: Colors.blue[500]),
                      ),
                      Stack(
                        children: <Widget>[
                          Container(
                              height: 50.0,
                              width: 50.0,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blue[500]),
                                  shape: BoxShape.circle,
                                  color: Colors.blue[500])),
                          Container(
                              height: 50.0,
                              width: 50.0,
                              child: Center(
                                child: Text(event['maxTeamSize'].toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold)),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10.0),
                  height: 100.0,
                  width: 150.0,
                  decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.all(Radius.circular(10.0)),
                      border: Border.all(
                        width: 2.0,
                        color: Colors.blue[500],
                      )),
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Text(
                          'Venue',
                          style: headStyle(20.0),
                        ),
                      ),
                      Container(
                        width: 70.0,
                        child: Divider(
                          color: Colors.blue[500],
                          thickness: 2.0,
                        ),
                      ),
                      Center(
                        child: Text('Online', style: headStyle(30.0)),
                      )
                    ],
                  ),
                ),
              ],
            ))
      ],
    ),
  );
}

TextStyle headStyle(double fs) {
  return TextStyle(
    color: Colors.white,
    fontSize: fs,
  );
}