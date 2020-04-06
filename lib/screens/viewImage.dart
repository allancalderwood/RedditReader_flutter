import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:redditreader_flutter/models/comment.dart';
import 'package:redditreader_flutter/models/post.dart';
import 'package:redditreader_flutter/styles/theme.dart';
import 'package:redditreader_flutter/utils/commentFactory.dart';
import 'package:redditreader_flutter/widgets/commentBuilder.dart';
import 'package:redditreader_flutter/widgets/expandedPost.dart';
import 'package:redditreader_flutter/utils/redditAPI.dart';

class ImagePage extends StatefulWidget {
  ImagePage({Key key, this.post}) : super(key: key);
  final Post post;

  @override
  _ImagePageState createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  initState(){
    super.initState();
  }

  void saveToDevice(){
    GallerySaver.saveImage(widget.post.imageURL).then((success) {
      setState(() {
        print("RR: WORKING");
        final snackBarContent = SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: currentTheme.accentColor,
          content: Text("Image Saved to Gallery", style: currentTheme.textTheme.bodyText1,),
        );
        _scaffoldkey.currentState.showSnackBar(snackBarContent);
      });
    });
  }

  // content of the screen
  @override
  Widget build(BuildContext context) {
     return Scaffold(
       key: _scaffoldkey,
       floatingActionButton: FloatingActionButton(
         onPressed: (){saveToDevice();},
         backgroundColor: currentTheme.backgroundColor,
         child: Icon(Icons.save, size: 25, color: currentTheme.primaryColor),
       ),
        body: Center(
          child: FadeInImage(
             image: NetworkImage(widget.post.imageURL),
             placeholder: NetworkImage(widget.post.imageURLPreview),
             fit: BoxFit.fill,
           ),
        )
    );
  }
}
