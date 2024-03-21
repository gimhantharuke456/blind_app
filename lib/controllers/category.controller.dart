import 'package:blind_app/models/category.model.dart';
import 'package:mongo_dart/mongo_dart.dart';

class CategoryController {
  final DbCollection categories;

  CategoryController(this.categories);

  // Create a new category
  Future<void> createCategory(Category category) async {
    await categories.insertOne(category.toMap());
  }

  // Retrieve a category by its ID
  Future<Category?> getCategoryById(ObjectId id) async {
    final result = await categories.findOne(where.id(id));
    if (result != null) {
      return Category.fromMap(result);
    }
    return null;
  }

  // Retrieve all categories or by parent category ID
  Future<List<Category>> getCategories({ObjectId? parentCategoryId}) async {
    var query = parentCategoryId != null
        ? where.eq('parentCategory', parentCategoryId.toHexString())
        : where.exists('name');
    final results = await categories.find(query).toList();

    return results.map((doc) => Category.fromMap(doc)).toList();
  }

  // Update a category
  Future<void> updateCategory(ObjectId id, Category updatedCategory) async {
    await categories.replaceOne(where.id(id), updatedCategory.toMap());
  }

  // Delete a category
  Future<void> deleteCategory(ObjectId id) async {
    await categories.deleteOne(where.id(id));
  }
}
