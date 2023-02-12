import 'lib/models/proudct.dart';

void main() {
  var p1 = Product(id: '1', title: 'title', description: 'description', price: 25.5, imageUrl: 'imageUrl');
  var p2 = Product(id: '1', title: 'title', description: 'description', price: 25.5, imageUrl: 'imageUrl');

  print(p1 == p2);
}
