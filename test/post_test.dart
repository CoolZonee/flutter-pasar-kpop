import 'package:test/test.dart';
import 'package:testing_app/class/post_class.dart';

void main() {
  test('test1', () {
    const randomPost = {
      "userId": 1,
      "id": 1,
      "title":
          "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
      "body":
          "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
    };

    final post = Post.fromJson(randomPost);

    // expect(post., 1);
    // expect(post._id, 1);
    // expect(post.title,
    //     'sunt aut facere repellat provident occaecati excepturi optio reprehenderit');
    // expect(post.body,
    //     'quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto');
  });

  // test('test2', () {

  // });
}
