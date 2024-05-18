class Menu {
  String Description;
  String ID;
  String Icon;
  String Name;
  double Price;
  String Shop_ID;
  String? type;
  bool inStock;

  Menu({
    required this.Description,
    required this.ID,
    required this.Icon,
    required this.Name,
    required this.Price,
    required this.Shop_ID,
    required this.inStock,
  });

  Menu.fromJson(Map<String, Object?> json)
      : this(
          Description: json['Description']! as String,
          ID: json['ID']! as String,
          Icon: json['Icon']! as String,
          Name: json['Name']! as String,
          Price: (json['Price']! as num).toDouble(),
          Shop_ID: json['Shop_ID']! as String,
          inStock: json['inStock']! as bool,
        );

  Menu copyWith({
    String? Description,
    String? ID,
    String? Icon,
    String? Name,
    double? Price,
    String? Shop_ID,
    bool? inStock,
  }) {
    return Menu(
      Description: Description ?? this.Description,
      ID: ID ?? this.ID,
      Icon: Icon ?? this.Icon,
      Name: Name ?? this.Name,
      Price: Price ?? this.Price,
      Shop_ID: Shop_ID ?? this.Shop_ID,
      inStock: inStock ?? this.inStock,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'Description': Description,
      'ID': ID,
      'Icon': Icon,
      'Name': Name,
      'Price': Price,
      'Shop_ID': Shop_ID,
      'inStock': inStock,
    };
  }
}
