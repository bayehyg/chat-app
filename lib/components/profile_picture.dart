import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  final String imageUrl;

  UserProfile({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    double widthRef = MediaQuery.of(context).size.width;

    return CircleAvatar(
      // radius: widthRef / 14,
      backgroundImage: CachedNetworkImageProvider(imageUrl),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
        imageBuilder: (context, imageProvider) => CircleAvatar(
          radius: 40.0,
          backgroundImage: imageProvider,
        ),
      ),
    );
  }
}
