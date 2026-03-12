extends Node


var category_collections: Array[CategoryCollection]

var players: Array[Player] = []

var max_players: int = 7
var min_players: int = 2


var consonants: Array[String] = ["B", "C", "D", "F", "G", "H", "J", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "V", "W", "X", "Z"]
var vocals: Array[String] = ["A", "E", "I", "O", "U", "Y", "Æ", "Ø", "Å"]
var used_vocals: Array[String] = []

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

var player_colors: Array[PlayerColor] = [
	PlayerColor.new(0),
	PlayerColor.new(1),
	PlayerColor.new(2),
	PlayerColor.new(3),
	PlayerColor.new(4),
	PlayerColor.new(5),
	PlayerColor.new(6),
	PlayerColor.new(7),
	PlayerColor.new(8),
	PlayerColor.new(9),
	PlayerColor.new(10)
]

var player_jingles: Array[PlayerJingle] = [
	PlayerJingle.new(AudioID.JINGLE1, "Guitar 1"),
	PlayerJingle.new(AudioID.JINGLE2, "Guitar 2"),
	PlayerJingle.new(AudioID.JINGLE3, "Guitar 3"),
	PlayerJingle.new(AudioID.JINGLE4, "Guitar 4"),
	PlayerJingle.new(AudioID.JINGLE5, "Guitar 5"),
	PlayerJingle.new(AudioID.JINGLE6, "Guitar 6"),
	PlayerJingle.new(AudioID.JINGLE7, "Guitar 7"),
	PlayerJingle.new(AudioID.BATIATUS, "Batiatus"),
	PlayerJingle.new(AudioID.BOB, "Bob Ricketts"),
	PlayerJingle.new(AudioID.DRAGON_BALL, "Dragon Ball"),
	PlayerJingle.new(AudioID.EGON, "Egon Olsen"),
	PlayerJingle.new(AudioID.LAHEY, "Jim Lahey"),
	PlayerJingle.new(AudioID.RIV, "Ninja Turtles"),
	PlayerJingle.new(AudioID.SCOTT, "Micheal Scott")
]

func get_first_available_color_id():
	for i in range(player_colors.size()):
		if not player_colors[i].taken:
			return i

func get_first_available_jingle_id():
	for i in range(player_jingles.size()):
		if not player_jingles[i].taken:
			return i

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
	LOST_TURN,
	# jingles
	JINGLE1,
	JINGLE2,
	JINGLE3,
	JINGLE4,
	JINGLE5,
	JINGLE6,
	JINGLE7,
	BATIATUS,
	BOB,
	DRAGON_BALL,
	EGON,
	LAHEY,
	MEYER,
	RIV,
	SCOTT
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

