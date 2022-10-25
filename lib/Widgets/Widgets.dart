
import 'package:flutter/material.dart';
import 'package:instagram_analysys/Models/Model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BuildUser extends StatelessWidget {
  const BuildUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference users=FirebaseFirestore.instance.collection('UserData');
    return FutureBuilder(
        future: users.doc('thisisbillgates').get(),
        builder: (BuildContext context,AsyncSnapshot<DocumentSnapshot>snapshot){
         if(snapshot.hasError){
           return const Text('Something Went Wrong');
         }
         if(snapshot.hasData&&!snapshot.data!.exists){
           return const Text('Document Does Not Exist');
          }
         if(snapshot.connectionState==ConnectionState.done){
           final user=UserModel.fromJson(snapshot.data!.data() as Map<String, dynamic>);
           return Padding(
             padding: const EdgeInsets.only(top: 50),
             child: Column(
               children: [
                 ClipOval(
                   child: Image.network(user.profile,height: 120,width: 120,fit: BoxFit.fill,),
                 ),
                 const SizedBox(height: 10,),
                 Text(user.name,style: const TextStyle(fontWeight: FontWeight.bold),),
                 const SizedBox(height: 10,),
                 Text('Posts : ${user.posts} \t\tFollowers : ${user.followers}\t\tFollowings : ${user.followings}',),
               ],
             ),
           );
         }
         return const CircularProgressIndicator();
        }
    );
  }
}

class BuildPosts extends StatefulWidget {
  const BuildPosts({Key? key}) : super(key: key);

  @override
  State<BuildPosts> createState() => _BuildPostsState();
}

class _BuildPostsState extends State<BuildPosts> {
  final postStream=FirebaseFirestore.instance
      .collection('UserData')
      .doc('thisisbillgates')
      .collection('Posts')
      .snapshots()
      .map((snapshot) =>
  snapshot.docs.map((doc) => PostModel.fromJson(doc.data())).toList());
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<PostModel>>(
        stream: postStream,
        builder: (context,snapshot){
          if(snapshot.hasError){
            return const Text('Something went wrong');
          }
          if(snapshot.hasData){
            return ListView(
              scrollDirection: Axis.horizontal,
              children: snapshot.data!.map((post) => SizedBox(
                height: 350,
                width: 350,
                child: Card(
                  elevation: 10.0,
                  shadowColor: Colors.black38,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Image.network(post.imageURL,height: 250,width: 350,fit: BoxFit.fitWidth,),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(post.caption,overflow: TextOverflow.ellipsis,),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Row(
                          children: [
                            const Icon(Icons.favorite,color: Colors.blue,),
                            Text(' ${post.likes}   '),
                            const Icon(Icons.mode_comment_outlined,color: Colors.blue,),
                            Text(' ${post.comments}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )).toList(),
            );
          }
          return const CircularProgressIndicator();
        });
  }
}

class BuildChart extends StatefulWidget {
  const BuildChart({Key? key}) : super(key: key);

  @override
  State<BuildChart> createState() => _BuildChartState();
}

class _BuildChartState extends State<BuildChart> {
  List<ChartModel> chartdata=[];
  TooltipBehavior? _tooltipBehavior;
  @override
  void initState(){
    chartdata=getChartData();
    _tooltipBehavior=TooltipBehavior(enable: true);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 100,right: 5.0,left: 5.0),
      child: SizedBox(
        height: 300,
        width: MediaQuery.of(context).size.width,
        child: chartdata.isNotEmpty?SfCartesianChart(
          title: ChartTitle(text: 'Social Analysys'),
          tooltipBehavior: _tooltipBehavior,
          primaryXAxis: NumericAxis(labelFormat: 'C :{value}'),
          primaryYAxis: NumericAxis(labelFormat: 'L :{value}'),
          series: <ChartSeries>[
            LineSeries<ChartModel,int>(
              name: 'Bill Gates',
              dataSource: chartdata,
                xValueMapper: (ChartModel chart,_)=>chart.comments,
                yValueMapper: (ChartModel chart,_)=>chart.likes,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              enableTooltip: true,
            ),
          ],
        ):IconButton(onPressed: ()=>setState((){}), icon: const Icon(Icons.refresh)),
      ),
    );
  }
}



