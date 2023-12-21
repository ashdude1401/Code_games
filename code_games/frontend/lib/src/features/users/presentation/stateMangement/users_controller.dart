// //to-do importing all user realted code

// import 'package:code_games/src/features/auth/data/models/user_modal.dart';
// import 'package:code_games/src/features/creating_rooms/data/repository/group_repository_impl.dart';

// import 'package:get/get.dart';

// class UserController extends GetxController {
//   final controller = Get.put(GroupRepositoryImpl());

//   final allUsers = Rx<List<UserEntity>>([]);
//   final isLoading = false.obs;

//   @override
//   void onReady() {
//     getAllusers();
//     // TODO: implement onReady
//     super.onReady();
//   }

//   Future<void> getAllusers() async {
//     List<Map<String, dynamic>> users = [];
//     try {
//       isLoading.value = true;
//       final users = await controller.getAllUsers();
//       allUsers.value = users.map((user) => UserEntity.fromMap(user)).toList();
//       isLoading.value = false;
//     } catch (e) {
//       isLoading.value = false;
//       print("Error: $e");
//     }
//   }
// }
