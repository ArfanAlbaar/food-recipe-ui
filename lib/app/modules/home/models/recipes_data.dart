class Recipe {
  final int id;
  final String recipeName;
  final List<String> ingredients;
  final List<String> instructions;
  final String category;
  final bool favorite;
  final String imgLink;

  Recipe({
    required this.id,
    required this.recipeName,
    required this.ingredients,
    required this.instructions,
    required this.category,
    required this.favorite,
    required this.imgLink,
  });
}
