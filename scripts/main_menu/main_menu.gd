class_name MainMenu extends Control

@export var player_settings_node: PackedScene
@export var player_settings_parent: VBoxContainer
@export var start_button: Button
@export var add_player: Button


var player_settings: Array[PlayerSetting]

func _ready() -> void:
	AudioManager.stop_all()
	start_button.disabled = false
	for i in  range(GameData.player_colors.size()):
		GameData.player_colors[i].taken = false
	for i in range(GameData.player_jingles.size()):
		GameData.player_jingles[i].taken = false
	player_settings.clear()
	GameData.players.clear()

	AudioManager.on_fade_finished.connect(_audio_fade_done)

	_setup_audio()

	start_button.pressed.connect(_on_start)
	add_player.pressed.connect(_on_add_player)

	_create_player()
	_create_player()

func _audio_fade_done(_bus: AudioManager.BusID):
	AudioManager.stop(AudioManager.BusID.BACKGROUND, true)
	AudioManager.set_volume(AudioManager.BusID.BACKGROUND, 0.0)
	GameData.Scenes.switch_to(GameData.Scenes.transition)

func _setup_audio():
	AudioManager.set_volume(AudioManager.BusID.BACKGROUND,-12.0)	
	AudioManager.play(AudioManager.BusID.BACKGROUND, GameData.AudioID.THEME_SONG_SEGMENTED, AudioResource.Mode.LOOP_VARIANT, 1)
	

func _create_player(_name:String = "Spiller"):
	var _number = player_settings.size() + 1
	print("Adding player: ", _number)
	var full_name = _name + " " + str(_number)
	
	var player_setting = player_settings_node.instantiate()
	player_setting.set_player_name(full_name)

	var color_id = GameData.get_first_available_color_id()
	print("Color id: ", color_id)
	player_setting.set_color(color_id)	
	var audio_id = GameData.get_first_available_jingle_id()
	player_setting.set_jingle(audio_id)

	player_setting.on_remove.connect(_on_remove_player)

	player_settings_parent.add_child(player_setting)
	player_settings.append(player_setting)


func _on_remove_player(player_setting: PlayerSetting):
	if player_settings.size() > GameData.min_players:
		print("Removing player: ", player_setting.player_number)

		GameData.player_colors[player_setting.color_id].taken = false
		if player_setting in player_settings:
			player_settings.erase(player_setting) 
		player_setting.queue_free()

func _on_start():
	print("--- starting game ---")
	print("--- Config ---")
	print("Rounds: ", GameData.n_rounds)
	print("Bonus: ", GameData.round_bonus)
	print("Starting jokers: ", GameData.n_start_jokers)
	print("Vocal cost: ", GameData.vocal_cost)
	print("Player count: ", player_settings.size())
	for i in range(player_settings.size()):
		var player = Player.new(
			player_settings[i].get_player_name(), 
			(i+1),
			GameData.player_colors[player_settings[i].color_id].get_color(),
			GameData.n_start_jokers,
			GameData.player_jingles[player_settings[i].sound_id].audio_id) 
		GameData.players.append(player)
		
	AudioManager.fade_volume(AudioManager.BusID.BACKGROUND, -15.0, 1.0) 
	start_button.disabled = true

	
	

func _on_add_player():
	if player_settings.size() < GameData.max_players:
		_create_player()
	
