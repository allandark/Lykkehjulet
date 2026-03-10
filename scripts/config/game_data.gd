extends Node


var category_collections: Array[CategoryCollection]

var players: Array[Player] = []

var max_players: int = 7
var min_players: int = 2


var consonants: Array[String] = ["B", "C", "D", "F", "G", "H", "J", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "V", "W", "X", "Z"]
var vocals: Array[String] = ["A", "E", "I", "O", "U", "Y", "Æ", "Ø", "Å"]


var max_rounds: int = 200
var min_rounds: int = 1

var max_bonus: int = 9999
var min_bonus: int = 0

var max_jokers: int = 20

# Config values
var round_bonus: int = 500
var n_rounds: int = 3
var n_start_jokers: int = 0
var vocal_cost: int = 500



var colors: Array[Color] = [
	Color.BLUE, 
	Color.RED,
	Color.GREEN,
	Color.YELLOW,
	Color.AQUA,
	Color.FUCHSIA,	
	Color.MAROON,
	Color.NAVY_BLUE,
	Color.OLIVE,
	Color.TEAL,
	Color.PURPLE
]

var color_labels: Array[String] = [
	"Blå",
	"Rød",
	"Grøn",
	"Gul",
	"Turkis",
	"Magenta",	
	"Kastanje",
	"Marineblå",
	"Oliven",
	"Blågrøn",
	"Lilla"
]

var taken_colors: Array[bool] = [
	false,
	false,
	false,
	false,
	false,
	false,
	false,	
	false,
	false,
	false,
	false		
]

func get_first_available_color_id():
	for i in range(taken_colors.size()):
		if not taken_colors[i]:
			return i

func get_color_string(color: Color):
	if color == Color.BLUE:
		return "blue"
	elif color == Color.RED:
		return "red"
	elif color == Color.GREEN:
		return "green"
	elif color == Color.YELLOW:
		return "yellow"
	elif color == Color.AQUA:
		return "aqua"
	elif color == Color.FUCHSIA:
		return "fuchsia"
	elif color == Color.LIME:
		return "lime"
	elif color == Color.MAROON:
		return "maroon"
	elif color == Color.NAVY_BLUE:
		return "navy"
	elif color == Color.OLIVE:
		return "olive"
	elif color == Color.PURPLE:
		return "purple"
	return ""


var selected_border_color = Color(1.0, 1.0, 1.0, 1.0)
var border_color = Color(0.6, 0.6, 0.6, 0.8)  
var max_player_name_length: int = 14

enum AudioID{
	# music
	THEME_SONG_SEGMENTED,
	THEME_SONG_SHORT,
	THEME_SONG_FULL,
	# effects
	WOF_TICK,
	ERROR,
	WIN_GUITAR,
	CORRECT,
	WRONG,
	FALLIT,
	ROUND_END,
	APPLAUSE,
	NORMAL_WEDGE,
	JOKER,
	LOST_TURN
}



class Scenes:
	static var main_menu: PackedScene = load("res://scenes/main_menu.tscn") as PackedScene	
	static var transition: PackedScene = load("res://scenes/transition_to_game.tscn") as PackedScene	
	static var in_game: PackedScene = load("res://scenes/game_scene.tscn") as PackedScene
	

	static func switch_to(scene: PackedScene):
		var new_scene = scene.instantiate()
		var old_scene = Engine.get_main_loop().current_scene
		Engine.get_main_loop().root.add_child(new_scene)
		Engine.get_main_loop().current_scene = new_scene
		if old_scene:
			old_scene.queue_free()



func _ready():
	
	load_all_categories_from_folder("res://game_data")
	category_collections[0].is_selected = true # TEMP
	
	


func load_all_categories_from_folder(folder_path: String) -> void:
	var dir = DirAccess.open(folder_path)

	if not dir:
		push_error("Failed to open directory: %s" % folder_path)
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		if not dir.current_is_dir():
			if file_name.get_extension().to_lower() == "json":
				var full_path = folder_path + "/" + file_name
				load_category_file(full_path)
		file_name = dir.get_next()

	dir.list_dir_end()

	print("Finished loading categories. Total:", category_collections.size())


func load_category_file(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)

	if not file:
		push_error("Failed to open JSON file: %s" % path)
		return

	var json_text = file.get_as_text()
	file.close()

	var parser = JSON.new()
	var error_code = parser.parse(json_text)

	if error_code != OK:
		push_warning("Invalid JSON file (%s), error code: %d" % [path, error_code])
		return

	var json_dict = parser.get_data()

	if not json_dict.has("name"):
		push_warning("JSON missing 'name' field: %s" % path)
		return

	var collection = CategoryCollection.new(json_dict["name"], json_dict)
	category_collections.append(collection)	

	print("Category loaded successfully from: ", path)

