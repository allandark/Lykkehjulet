class_name Player
var name: String
var balance: int
var color: Color
var number: int
var jokers: int

func _init(_name: String, _number: int ,_color: Color) -> void:
	name = _name
	balance = 0
	jokers = 2
	color = _color
	number = _number
