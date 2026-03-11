class_name PlayerSetting extends Panel

@export var player_name_edit : LineEdit
@export var color_rect: ColorRect
@export var color_options : OptionButton
@export var sound_options: OptionButton
@export var play_button: Button
@export var remove_button: Button 


var player_name: String
var player_number: int
var color_id: int
var sound_id: int

signal on_remove(setting: PlayerSetting)

func _ready() -> void:
	color_options.item_selected.connect(_on_color_option_selected)
	sound_options.item_selected.connect(_on_sound_option_selected)
	remove_button.pressed.connect(_on_remove_button_pressed)
	play_button.pressed.connect(_on_play_button_pressed)
	player_name_edit.max_length = GameData.max_player_name_length
	reset_color_options()
	reset_audio_options()


func reset_color_options():
	color_options.clear()
	for i in range(GameData.player_colors.size()):		
			color_options.add_item(GameData.player_colors[i].get_label(), i)

func reset_audio_options():
	sound_options.clear()
	for i in range(GameData.player_jingles.size()):
		sound_options.add_item(GameData.player_jingles[i].label)

func set_player_name(_name: String):
	player_name = _name
	player_name_edit.text = player_name

func get_player_name()-> String:
	player_name = player_name_edit.text
	return player_name

func set_color(_color_id : int):
	color_id = _color_id
	color_options.call_deferred("select", color_id)
	color_rect.color = GameData.player_colors[color_id].get_color()	
	GameData.player_colors[color_id].taken = true	

func set_jingle(_jingle_id: GameData.AudioID):
	sound_id = _jingle_id
	sound_options.call_deferred("select", sound_id)
	GameData.player_jingles[sound_id].taken = true	

func _on_color_option_selected(index: int) -> void:
	if GameData.player_colors[index].taken:
		color_options.selected = color_id
	else:
		GameData.player_colors[color_id].taken = false	
		color_id = index
		color_rect.color = GameData.player_colors[color_id].get_color()
		GameData.player_colors[color_id].taken = true	

func _on_sound_option_selected(index: int) -> void:	
	if GameData.player_jingles[index].taken:
		sound_options.selected = sound_id
	else:
		GameData.player_jingles[sound_id].taken = false	
		sound_id = index		
		GameData.player_jingles[sound_id].taken = true	

func _on_remove_button_pressed():
	emit_signal("on_remove", self)

func _on_play_button_pressed():
	AudioManager.stop(AudioManager.BusID.EFFECT, true)
	AudioManager.play(AudioManager.BusID.EFFECT, GameData.player_jingles[sound_id].audio_id)
