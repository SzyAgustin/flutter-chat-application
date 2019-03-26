import 'package:chat_application/handleDB/db_management.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoView extends StatefulWidget {
  PhotoView({this.photo});
  final Image photo;

  @override
  _PhotoViewState createState() => _PhotoViewState();
}

class _PhotoViewState extends State<PhotoView> {
  bool isChangingPhoto = false;
  Stream<Image> photo;

  @override
  void initState() {
    photo = DbManagement().getStoredPhotoStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FittedBox(
          child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Container(
            height: 500,
            child: StreamBuilder<Image>(
                stream: photo,
                builder: (context, snapshot) {
                  if (isChangingPhoto) {
                    return Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue)),
                    );
                  }
                  return snapshot.data;
                }),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 120,
              child: changePhotoButton(),
            ),
          ),
        ],
      )),
    );
  }

  void pickPhoto() async {
    var tempPhoto = await ImagePicker.pickImage(source: ImageSource.gallery);
    final StorageReference ref = FirebaseStorage.instance
        .ref()
        .child(DbManagement.user.uid + '-profilePhoto.jpg');
    final StorageUploadTask task = ref.putFile(tempPhoto);

    if (task.isInProgress) {
      setState(() {
        isChangingPhoto = true;
      });
    }

    // final downloadUrl = await (await task.onComplete).ref.getDownloadURL();
    // DbManagement().updateUrlImageToUser(downloadUrl);

    task.onComplete.then((snap) {
      snap.ref.getDownloadURL().then((url) {
        DbManagement().updateUrlImageToUser(url);
        if (task.isComplete) {
          setState(() {
            isChangingPhoto = false;
          });
        }
      });
    });
  }

  Widget changePhotoButton() {
    if (isChangingPhoto) {
      return Text("");
    }
    return GestureDetector(
      onTap: pickPhoto,
      child: Opacity(
        opacity: 0.5,
        child: Container(
          color: Colors.black,
          child: Center(
            child: Text(
              "Change Picture",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  decoration: TextDecoration.none),
            ),
          ),
        ),
      ),
    );
  }
}
