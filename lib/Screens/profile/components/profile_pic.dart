import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graduationproject/components/MessageDialog.dart';
import 'package:graduationproject/data_models/Patient.dart';
import 'package:graduationproject/firebase/auth/auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilePic extends StatelessWidget with CanShowMessages{
  ProfilePic({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FireBaseAuth>(context,listen: true).loggedUser;
    String photoUri = Provider.of<FireBaseAuth>(context,listen: true).photoUri;
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        overflow: Overflow.visible,
        children: [
          CircleAvatar(
            backgroundImage: photoUri == null || photoUri == '' ? AssetImage("assets/images/Profile Image.png"): NetworkImage(photoUri ) ,
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: BorderSide(color: Colors.white),
                ),
                color: Color(0xFFF5F6F9),
                onPressed: () async {
                  try {
                    final picker = ImagePicker();
                    final pickedFile = await picker.getImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      File file = File(pickedFile.path);
                      await Provider.of<FireBaseAuth>(context,listen: false).changeUserProfileImage(file: file);
                    }
                  }catch(e){ }
                },
                child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
