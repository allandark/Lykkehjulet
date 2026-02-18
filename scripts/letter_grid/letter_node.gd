extends Control

@export var label: Label
@export var hidden_rect: TextureRect
@export var unused_rect: TextureRect

var pos_x = -1
var pox_y = -1

func set_hidden(value : bool):
	hidden_rect.visible = value

func is_hidden():
	return hidden_rect.visible

func set_unused(value : bool):
	unused_rect.visible = value

func is_unused():
	return unused_rect.visible

func set_letter(value : String):
	label.text = value[0]
