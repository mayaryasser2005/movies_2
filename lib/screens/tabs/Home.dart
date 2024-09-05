import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies_2/api_manager.dart';

import '../../model/popular.dart';
import '../../widget/New_Releases.dart';
import '../../widget/popular_slider.dart';

class HomeTab extends StatefulWidget {
  static const String routeNamed = "home";
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late Future<List<PopularResponse>> popular;
  void initState(){
    super.initState();
    popular = ApiManager.getPopular() ;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movies",),
        centerTitle: true,
      ),
      body: Container(
        child: SingleChildScrollView(physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 32,),
                SizedBox(
                  child: FutureBuilder(
                    future: popular,
                    builder: (context, snapshot) {
                      if(snapshot.hasError){
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      }else if(snapshot.hasData){
                        // final data = snapshot.data;
                        return PopularSlider(snapshot:snapshot);
                      }else{
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
                SizedBox(height: 32,),
                Text(
                    "New Releases"
                    ,style: GoogleFonts.aBeeZee(
                  fontSize: 25
                ),
                ),
                SizedBox(height: 32,),
                NewReleasesSlider(),
                Text(
                  "Recomended"
                  ,style: GoogleFonts.aBeeZee(
                    fontSize: 25
                ),
                ),
                SizedBox(height: 32,),
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      itemCount: 10,
                      itemBuilder: (context ,index){
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              color: Colors.amber,
                              height: 200,
                              width: 150,
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
