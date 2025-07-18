import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  Future<void> addUserOrderDetail(
      Map<String, dynamic> userOrderMap, String id, String orderId) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('orders')
        .doc(orderId)
        .set(userOrderMap, SetOptions(merge: true));
  }
  Future<void> addAdminOrderDetail(
      Map<String, dynamic> userOrderMap, String id, String orderId) async {
    return await FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId)
        .set(userOrderMap, SetOptions(merge: true));
  }
}
