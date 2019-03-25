import 'package:chat_application/handleDB/db_management.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoView extends StatelessWidget {
  PhotoView({this.photo});
  final Image photo;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FittedBox(
          child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          photo,
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 30,
              child: changePhotoButton(),
            ),
          ),
        ],
      )),
    );
  }

  void pickPhoto() async {
    var tempPhoto = await ImagePicker.pickImage(source: ImageSource.gallery);
    // setState(() {
    //   _image = tempPhoto as Image;
    // });
    final StorageReference ref = FirebaseStorage.instance
        .ref()
        .child(DbManagement.user.uid + '-profilePhoto.jpg');
    final StorageUploadTask task = ref.putFile(tempPhoto);
    final downloadUrl = await (await task.onComplete).ref.getDownloadURL();
    DbManagement().updateUrlImageToUser(downloadUrl);
        
  }

  Widget changePhotoButton() {
    return GestureDetector(
      onTap: pickPhoto,
      child: Opacity(
        opacity: 0.5,
        child: Container(
          color: Colors.black,
          child: Center(
            child: Text(
              "Change Picture",
              style: TextStyle(color: Colors.white, fontSize: 4, decoration: TextDecoration.none),
            ),
          ),
        ),
      ),
    );
  }
}
