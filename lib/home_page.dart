import 'package:flutter/material.dart';
import 'package:reto_flutter/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  VoteBloc voteBloc;

  @override
  void initState() {
    voteBloc = VoteBloc();
    voteBloc.initPusher();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyInheritedWidget(
      voteBloc: voteBloc,
      child: AnimatedBuilder(
        animation: voteBloc,
        builder: (BuildContext context, Widget child) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Encuesta",
                  style: TextStyle(color: Colors.black, fontSize: 30)),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            body: Column(
              children: [
                Expanded(
                    flex: 2,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: voteBloc.candidatesName.length,
                        itemBuilder: (context, index) {
                          return PlaceItem(
                            title: voteBloc.candidatesName[index],
                            votes: voteBloc.candidatesVote[index],
                          );
                        })),
                Expanded(
                  flex: 5,
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: voteBloc.voters.length,
                      itemBuilder: (context, i) {
                        return ListTile(
                          title: Text(voteBloc.voters[i].name),
                          subtitle: Text(voteBloc.voters[i].candidate),
                          leading: Icon(Icons.people),
                        );
                      }),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PlaceItem extends StatelessWidget {
  String title;
  int votes;

  PlaceItem({this.title, this.votes});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.all(10),
          width: 100,
          height: 100,
          decoration: BoxDecoration(
              color: Colors.pink[200], borderRadius: BorderRadius.circular(10)),
          child: Text(
            title,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Text(votes.toString(),
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))
      ],
    );
  }
}

class MyInheritedWidget extends InheritedWidget {
  final Widget child;
  final VoteBloc voteBloc;

  MyInheritedWidget({@required this.voteBloc, @required this.child});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}
