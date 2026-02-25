extends Node

@export var player_color: Color

@export var bg_color_rect : ColorRect
@export var border_rect: TextureRect
@export var label : Label
@export var digit_lavels: Array[Label]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bg_color_rect.color = player_color


func set_player_name(_name : String):
	label.text = _name

func set_balance(value : int):
	value = clamp(value, 0, 99999)
	var str_value = str(value)
	while str_value.length() < 5:
				str_value = "0" + str_value
	for i in range(5):
		digit_lavels[i].text = str_value[i]

func set_active(value: bool):
	if value:
		border_rect.modulate = GameData.selected_border_color
	else:
		border_rect.modulate = GameData.border_color
