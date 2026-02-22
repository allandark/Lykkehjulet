extends Node


var categories : CategoryCollection

var players: Array[Player] = [
	Player.new("Spiller 1", 1, Color.BLUE), 
	Player.new("Spiller 2", 2, Color.RED),
	Player.new("Spiller 3", 3, Color.GREEN),
	Player.new("Spiller 4", 4, Color.YELLOW),
]
var n_rounds: int = 3

var consonants = ["B", "C", "D", "F", "G", "H", "J", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "V", "W", "X", "Z"]
var vocals = ["A", "E", "I", "O", "U", "Y", "Æ", "Ø", "Å"]

var round_bonus = 500

func get_color_string(color: Color):
	if color == Color.BLUE:
		return "blue"
	elif color == Color.RED:
		return "red"
	elif color == Color.GREEN:
		return "green"
	elif color == Color.YELLOW:
		return "yellow"
	return ""

func _ready():
	load_categories()


func load_categories():
	var file = FileAccess.open("res://game_data/common.json", FileAccess.READ)
	if file:
		var json_text = file.get_as_text()
		file.close()		
		var parser = JSON.new()
		var error_code  = parser.parse(json_text)
		
		if error_code != OK:
			push_warning("Invalid JSON file, error code: %d" % error_code)
			return  
		var json_dict = parser.get_data()  
		categories = CategoryCollection.new(json_dict["name"], json_dict)
		print("categories loaded successfully!")

	else:
		push_error("Failed to open JSON file.")
