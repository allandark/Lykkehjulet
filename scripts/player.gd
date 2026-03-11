class_name Player
var name: String
var balance: int
var color: Color
var number: int
var jokers: int
var jingle: GameData.AudioID

func _init(_name: String, _number: int ,_color: Color, _jokers: int, _jingle_id) -> void:
	name = _name
	balance = 0
	jokers = _jokers
	color = _color
	number = _number
	jingle = _jingle_id
