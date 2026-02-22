class_name CategoryCollection

var name: String
var data: Dictionary
var categories: Array = [] 

func _init(_name: String, _data: Dictionary) -> void:
    name = _name
    data = _data
    categories = []

    if data.has("categories"):
        for cat in data["categories"]:         
            var new_cat = Category.new(cat.get("name", ""), cat.get("values", []))
            categories.append(new_cat)

func get_category(cat_name: String) -> Category:
    for cat in categories:
        if cat.name == cat_name:
            return cat
    return null

func get_random_category() -> Category:
    if categories.size() == 0:
        return null
    return categories[randi() % categories.size()]