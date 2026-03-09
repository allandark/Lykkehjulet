class_name Player
var name: String
var balance: int
var color: Color
var number: int
var jokers: int

func _init(_name: String, _number: int ,_color: Color, _jokers: int) -> void:
	name = _name
	balance = 0
	jokers = _jokers
	color = _color
	number = _number
