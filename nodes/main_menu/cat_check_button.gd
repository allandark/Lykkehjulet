class_name CatButton extends CheckButton


var cat_name: String
var id: int
var is_selected:bool = false

func _ready() -> void:

	toggled.connect(_on_toggled)	


func set_btn(_name: String, _id: int)->void:
	cat_name = _name
	id = _id
	text = _name
	if id == 0:
		is_selected = true
		set_pressed(is_selected)
		GameData.category_collections[id].is_selected = is_selected

	

func _on_toggled(pressed_state: bool) -> void:
	is_selected = pressed_state
	GameData.category_collections[id].is_selected = is_selected