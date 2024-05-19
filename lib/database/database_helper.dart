import 'package:chat_box_ai/model/chat_model.dart';
import 'package:localstore/localstore.dart';

class ChatDatabase {
  final db = Localstore.instance;

  Future<List<Map<String, dynamic>>> getDataCollection() async {
    final snapshot = await db.collection('chat').get();
    final List<Map<String, dynamic>> responseData = [];

    snapshot?.forEach((key, value) {
      responseData.add(value);
    });
    return responseData;
  }

  void removeDoc({required String docID}) {
    db.collection('chat').doc(docID).delete();
  }

  void updateDoc({required Chat chat}) {
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
