import 'package:scoped_model/scoped_model.dart';
import './product-model.dart';
import './user-model.dart';

class MainModel extends Model with UserModel, ProductsModel {
  
}