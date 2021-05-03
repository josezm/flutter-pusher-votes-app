import 'package:flutter/cupertino.dart';
import 'package:pusher_client/pusher_client.dart';
import 'dart:convert';

class VoteBloc extends ChangeNotifier {
  List<String> candidatesName = [];
  List<int> candidatesVote= [];
  List<Voter> voters = [];

  PusherClient pusher;
  Channel channel;

  PusherOptions options = PusherOptions(
      cluster: 'us2'
  );


  Future<void> initPusher() async {
    this.pusher = PusherClient('f85420797d61c4c65a80', options, autoConnect: false);
    pusher.connect();
    pusher.onConnectionStateChange((state) { print(state);});
    pusher.onConnectionError((error) {print(error);});

    this.channel = pusher.subscribe("private_vote");
    this.channel.bind('vote', (event) {
      Vote vote = voteFromJson(event.data);
      if(candidatesName.contains(vote.candidate)){
        candidatesVote[candidatesName.indexOf(vote.candidate)] += 1;
      }
      else{
        candidatesName.add(vote.candidate);
        candidatesVote.add(1);
      }
      
      Voter newVoter = Voter(vote.name, vote.candidate);
      this.voters.add(newVoter);

      notifyListeners();
    });

  }

  Future<void> closePusher () async{
    this.pusher.unsubscribe("private_vote");
    this.pusher.disconnect();
  }




}

Vote voteFromJson(String str) => Vote.fromJson(json.decode(str));
String voteToJson(Vote data) => json.encode(data.toJson());

class Vote {
  Vote({
    this.candidate,
    this.name,
  });

  String candidate;
  String name;

  factory Vote.fromJson(Map<String, dynamic> json) => Vote(
        candidate: json["candidate"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "candidate": candidate,
        "name": name,
      };
}


class Voter{
  String name;
  String candidate;

  Voter(String name, String candidate){
    this.name = name;
    this.candidate = candidate;
  }
}