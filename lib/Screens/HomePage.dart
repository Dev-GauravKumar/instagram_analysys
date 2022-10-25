import 'package:flutter/material.dart';
import 'package:instagram_analysys/Widgets/Widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.menu))
        ],
      ),
        body: Stack(
          children:[
            Image.asset('assets/Vector1.png'),
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset('assets/Vector2.png'),
            ),
            const Center(
              child: BuildUser(),
            ),
            const Center(child: BuildChart()),
            const Padding(
              padding: EdgeInsets.only(top: 530,bottom: 10),
              child: BuildPosts(),
            ),
          ],
        ),
    );
  }
}
