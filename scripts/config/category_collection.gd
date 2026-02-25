class_name CategoryCollection

var name: String
var data: Dictionary
var categories: Array[Category]
var is_selected: bool

func _init(_name: String, _data: Dictionary) -> void:
    name = _name
    data = _data
    categories = []
    is_selected = false

    if data.has("categories"):
        for cat in data["categories"]:         
            var new_cat = Category.new(cat.get("name", ""), cat.get("values", []))
            categories.append(new_cat)

func get_category(cat_name: String) -> Category:
    for cat in categories:
        if cat.name == cat_name:
            return cat
    return null

