class_name GameSettingsPanel extends Node

@export var n_rounds_spin : SpinBox
@export var round_bonus_spin : SpinBox
@export var n_jokers_spin : SpinBox
@export var vocal_cost_spin : SpinBox
@export var cat_button: PackedScene
@export var cat_button_parent: VBoxContainer

var cat_buttons: Array[CatButton]

func _ready() -> void:
	
	n_rounds_spin.min_value = GameData.min_rounds
	n_rounds_spin.max_value = GameData.max_rounds 
	n_rounds_spin.value = GameData.n_rounds
	
	round_bonus_spin.min_value = GameData.min_bonus
	round_bonus_spin.max_value = GameData.max_bonus
	round_bonus_spin.value = GameData.round_bonus
	
	n_jokers_spin.min_value = 0
	n_jokers_spin.max_value = GameData.max_jokers
	n_jokers_spin.value = GameData.n_start_jokers
	
	vocal_cost_spin.min_value = 0
	vocal_cost_spin.max_value = GameData.max_bonus
	vocal_cost_spin.value = GameData.vocal_cost
	
	n_rounds_spin.value_changed.connect(_n_rounds_changed)
	round_bonus_spin.value_changed.connect(_round_bonus_changed)
	n_jokers_spin.value_changed.connect(_jokers_changed)
	vocal_cost_spin.value_changed.connect(_vocal_cost_changed)

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

func _jokers_changed(value : int):
	GameData.n_start_jokers = value

func _vocal_cost_changed(value : int):
	GameData.vocal_cost = value
