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
	color_options.connect("item_selected", Callable(self, "_on_color_option_selected"))
	sound_options.connect("item_selected", Callable(self, "_on_sound_option_selected"))
	remove_button.connect("pressed", Callable(self, "_on_remove_button_pressed"))
	play_button.connect("pressed", Callable(self, "_on_play_button_pressed"))
	player_name_edit.max_length = GameData.max_player_name_length
	reset_color_options()


func reset_color_options():
	color_options.clear()
	for i in range(GameData.colors.size()):		
			color_options.add_item(GameData.color_labels[i], i)


func set_player_name(_name: String):
	player_name = _name
	player_name_edit.text = player_name

func get_player_name()-> String:
	player_name = player_name_edit.text
	return player_name

func set_color(_color_id : int):
	color_id = _color_id
	color_options.call_deferred("select", color_id)
	color_rect.color = GameData.colors[color_id]	
	GameData.taken_colors[color_id] = true	

func _on_color_option_selected(index: int) -> void:
	if GameData.taken_colors[index]:
		color_options.selected = color_id
	else:
		GameData.taken_colors[color_id] = false	
		color_id = index
		color_rect.color = GameData.colors[color_id]
		GameData.taken_colors[color_id] = true	

func _on_sound_option_selected(index: int) -> void:
	pass

func _on_remove_button_pressed():
	emit_signal("on_remove", self)

func _on_play_button_pressed():
	pass
