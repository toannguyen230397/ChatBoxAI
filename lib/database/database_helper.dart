import 'package:chat_box_ai/model/chat_model.dart';
import 'package:localstore/localstore.dart';

class ChatDatabase {
  // void createCollection(Chat chat, String msg) async {
  //   List<dynamic> newMessageList = [];
  //   newMessageList = await ChatAPI().sendRequest(msg, chat.message);
  //   final db = Localstore.instance;

  //   final id = db.collection('chat').doc().id;

  //   db.collection('chat').doc(id).set({
  //     'roomID': chat.roomID,
  //     'roomTitle': chat.roomTitle,
  //     'creatTime': chat.creatTime,
  //     'messege': newMessageList
  //   }).then((value) {
  //     print('succes');
  //   }).catchError((e) {
  //     print(e);
  //   });
  // }

  Future<List<Map<String, dynamic>>> getDataCollection() async {
    final db = Localstore.instance;
    final snapshot = await db.collection('chat').get();
    final List<Map<String, dynamic>> responseData = [];
    if (snapshot!.isNotEmpty) {
      snapshot.forEach((key, value) {
        responseData.add(value);
      });
    }
    return responseData;
  }

  void removeDoc({required String docID}) {
    final db = Localstore.instance;
    db.collection('chat').doc(docID).delete();
  }

  void updateDoc({required Chat chat}) {
    final db = Localstore.instance;
    db.collection('chat').doc(chat.roomID).set({
      'roomID': chat.roomID,
      'roomTitle': chat.roomTitle,
      'creatTime': chat.creatTime,
      'messege': chat.message
    }).then((value) {
      print('succes');
    }).catchError((e) {
      print(e);
    });
  }
}
