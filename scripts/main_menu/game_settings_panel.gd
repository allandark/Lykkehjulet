class_name GameSettingsPanel extends Node

@export var n_rounds_spin : SpinBox
@export var round_bonus_spin : SpinBox
@export var cat_button: PackedScene
@export var cat_button_parent: VBoxContainer

var cat_buttons: Array[CatButton]

func _ready() -> void:
	n_rounds_spin.connect("value_changed", Callable(self, "_n_rounds_changed"))
	round_bonus_spin.connect("value_changed", Callable(self, "_round_bonus_changed"))

	n_rounds_spin.value = GameData.n_rounds
	n_rounds_spin.min_value = GameData.min_rounds
	n_rounds_spin.max_value = GameData.max_rounds
	
	round_bonus_spin.min_value = GameData.min_bonus
	round_bonus_spin.max_value = GameData.max_bonus
	round_bonus_spin.value = GameData.round_bonus

	cat_buttons.clear()
	for i in range(GameData.category_collections.size()):
		var cat_btn = cat_button.instantiate()
		cat_btn.set_btn(GameData.category_collections[i].name, i)
		cat_button_parent.add_child(cat_btn)
		cat_buttons.append(cat_btn)
		


func _n_rounds_changed(value : int):
	GameData.n_rounds = value

func _round_bonus_changed(value : int):
	GameData.round_bonus = value


