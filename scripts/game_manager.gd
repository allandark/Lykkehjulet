extends Node

@export var wheel : Wheel
@export var info_box : InfoBox
@export var input_panel : InputPanel
@export var player_panel: PlayerPanel
@export var round_label: Label
@export var category_label: Label
@export var letter_grid : LetterGrid
@export var yes_no_modal: YesNoModal
@export var winner_panel: WinnerPanel


enum GameState{
	RUNNING,
	DONE
}

var game_state: GameState
var categories: Array[Category]
var current_player_id: int 
var current_player : Player
var current_round : int 
var winner : Player
var current_wedge: Dictionary
var round_starting_player_id: int
var first_turn: bool
var jingle_timer = null

var listen_input :bool = false


func _ready():
	wheel.spin_finished.connect(_on_wheel_finished)
	info_box.on_spin.connect(_on_spin)
	info_box.on_vokal.connect(_on_vokal)
	info_box.on_guess.connect(_on_guess)
	input_panel.on_submit.connect(_on_input_submit)
	yes_no_modal.on_button.connect(_on_modal)

	AudioManager.on_audio_finished.connect(_on_audio_finished)
	AudioManager.on_fade_finished.connect(_on_fade_finished)
	winner_panel.show_panel(false)

	AudioManager.set_volume(AudioManager.BusID.BACKGROUND, 0)
	AudioManager.set_volume(AudioManager.BusID.EFFECT, 0)

	input_panel.show_panel(false)
	_setup_game()

func _setup_game():	
	categories.clear()
	for i in range(GameData.category_collections.size()):
		if GameData.category_collections[i].is_selected:
			for cat in GameData.category_collections[i].categories:
				categories.append(cat)
	
	round_starting_player_id = randi_range(0, GameData.players.size()-1)
	current_round = 0
	first_turn = true
	game_state = GameState.RUNNING
	current_player = GameData.players[current_player_id]
	_reset_round()
	

func _reset_round():
	listen_input = false
	AudioManager.stop_all()
	AudioManager.play(AudioManager.BusID.EFFECT, GameData.AudioID.ROUND_END)
	current_round += 1
	round_label.text = "Runde: " + str(current_round)

	var cat = Category.get_random(categories)
	letter_grid.setup_category(cat)
	category_label.text = "Kategori: " + cat.name
	categories.erase(cat)
	print("reset round")
	_next_player()
	_start_turn()

func _next_player():
	for player in player_panel.players_containers:
		player.set_active(false)
	if first_turn:
		current_player_id = round_starting_player_id
		round_starting_player_id = (round_starting_player_id + 1) % GameData.players.size() # update for next turn
	else: 
		current_player_id = (current_player_id + 1) % GameData.players.size()
	current_player = GameData.players[current_player_id]
	play_jingle_delayed()
	info_box.set_button_states(true)
	
		
func _start_turn():
	player_panel.players_containers[current_player.number-1].set_active(true)
	print("starting turn")
	var player_text = "[color=%s]%s[/color]'s tur" % [PlayerColor.get_string(current_player.color), current_player.name]
	info_box.clear_line(1)
	info_box.clear_line(2)
	info_box.clear_line(3)
	info_box.show_text(player_text,1)
	info_box.set_button_states(true)
	# play_jingle_delayed()
	
	
	if current_player.balance >= GameData.vocal_cost:
		info_box.set_button_state(InfoBox.InfoButtonID.VOCAL, true)
	else:
		info_box.set_button_state(InfoBox.InfoButtonID.VOCAL, false)

func _end_turn()-> bool:
	if letter_grid.is_solved():
		current_player.balance += GameData.round_bonus
		player_panel.players_containers[current_player.number-1].set_balance(current_player.balance)
		info_box.clear_line(2)
		info_box.clear_line(3)
		if current_round == GameData.n_rounds:
			_end_of_game()
		else:
			var text = "[color=%s]%s[/color] vandt runden" % [PlayerColor.get_string(current_player.color), current_player.name]
			info_box.show_text(text, 2)
			info_box.show_text("Tryk enter for at starte næste runde", 3)
			info_box.set_button_states(false)
			listen_input = true				
			first_turn = true		
			AudioManager.play(AudioManager.BusID.BACKGROUND, GameData.AudioID.THEME_SONG_SEGMENTED, AudioResource.Mode.LOOP_VARIANT, 5)
			AudioManager.play(AudioManager.BusID.EFFECT, GameData.AudioID.APPLAUSE)
		
		print("solved")
		return true
	else:
		print("not solved")
		return false
	
func _end_of_game():	
	
	info_box.clear_text()
	info_box.show_text("Spillet er slut!",1)		
	info_box.set_button_states(false)
	winner = null
	for player in GameData.players:
		if winner == null:
			winner = player
		elif player.balance > winner.balance:
			winner = player
	
	winner_panel.set_winner_text(winner)
	winner_panel.show_panel(true)

	game_state = GameState.DONE
	# hack - delay listen_input 1 sec 	
	var timer = Timer.new()
	timer.wait_time = 2.0
	timer.one_shot = true 
	add_child(timer)
	timer.timeout.connect(func():
		listen_input = true
		timer.queue_free()
	)
	timer.start()
	AudioManager.play(AudioManager.BusID.EFFECT, GameData.AudioID.APPLAUSE)
	AudioManager.play(AudioManager.BusID.BACKGROUND, GameData.AudioID.THEME_SONG_FULL, AudioResource.Mode.LOOP_VARIANT, 0)


func play_jingle_delayed(delay_secs: float = 1.5):
	jingle_timer = get_tree().create_timer(delay_secs)
	jingle_timer.timeout.connect(_on_jingle_timer_timeout) 		

# Events/callbacks

func _on_jingle_timer_timeout() -> void:
	AudioManager.play(AudioManager.BusID.BACKGROUND, current_player.jingle)

func _on_audio_finished(_bus: AudioManager.BusID):
	AudioManager.set_volume(AudioManager.BusID.EFFECT, 0.0)

func _on_fade_finished(_bus: AudioManager.BusID):
	AudioManager.set_volume(AudioManager.BusID.BACKGROUND, 0.0)
	_switch_to_main_menu()

func _on_modal(button: YesNoModal.ButtonID):
	
	if button == YesNoModal.ButtonID.YES:		
		current_player.jokers = clamp(current_player.jokers - 1, 0, GameData.max_jokers)		
		yes_no_modal.show_modal(false)
		info_box.set_button_states(true)
		_start_turn()
	
	elif button == YesNoModal.ButtonID.NO:
		yes_no_modal.show_modal(false)
		_next_player()
		_start_turn()
	

func _switch_to_main_menu():
	GameData.Scenes.switch_to(GameData.Scenes.main_menu)


func _input(event):
	if not listen_input:
		return
	
	if game_state == GameState.RUNNING:
		if event.is_action_pressed("skip_keys"):
			_reset_round()
	elif game_state == GameState.DONE:
		if event.is_action_pressed("skip_keys"):
			AudioManager.fade_volume(AudioManager.BusID.BACKGROUND, -60, 2)			
		


func _on_input_submit(text: String):
	var result: bool = false
	if input_panel.state == input_panel.InputPanelState.CONSONANT:
		result = letter_grid.guess_consonant(text)
		if result:
			current_player.balance += current_wedge["amount"]
			player_panel.players_containers[current_player.number-1].set_balance(current_player.balance)
	elif input_panel.state == input_panel.InputPanelState.VOCAL:
		result = letter_grid.guess_vocal(text)
	elif input_panel.state == input_panel.InputPanelState.FULLWORD:
		result = letter_grid.guess_fullword(text)
	input_panel.show_panel(false)
	# info_box.set_button_states(true)
	if _end_turn():
		print("ending round")
		return
	if not result:
		AudioManager.play(AudioManager.BusID.EFFECT, GameData.AudioID.WRONG)
		if current_player.jokers > 0:
			input_panel.focus_locked = false
			yes_no_modal.set_joker(current_player.jokers)
			yes_no_modal.show_modal(true)
		else:
			_next_player()
	else:
		AudioManager.play(
			AudioManager.BusID.EFFECT, 
			GameData.AudioID.CORRECT,
			AudioResource.Mode.SINGLE_VARIANT,
			2)
	
	if game_state == GameState.RUNNING:
		_start_turn()


func _on_wheel_finished(index):
	current_wedge = WheelConfig.wedges[index]
	var text = WheelConfig.wedge_element_to_str(current_wedge)	
	info_box.show_text(text, 2)
	info_box.set_button_states(true)

	if current_wedge["type"] == WheelConfig.wedge_type.NORMAL:
		AudioManager.play(AudioManager.BusID.EFFECT, GameData.AudioID.NORMAL_WEDGE)
		info_box.set_button_states(false)
		info_box.show_text("Gæt en konsonant", 3)
		input_panel.set_state(InputPanel.InputPanelState.CONSONANT)
		input_panel.show_panel(true)
		# input_box.
	elif current_wedge["type"] == WheelConfig.wedge_type.BANKRUPT:
		AudioManager.play(AudioManager.BusID.EFFECT, GameData.AudioID.FALLIT)
		current_player.balance = 0
		player_panel.players_containers[current_player.number-1].set_balance(current_player.balance)
		_end_turn()
		_next_player()
		_start_turn()

	elif current_wedge["type"] == WheelConfig.wedge_type.LOSE_TURN:
		AudioManager.play(AudioManager.BusID.EFFECT, GameData.AudioID.LOST_TURN)
		_end_turn()
		_next_player()
		_start_turn()
	
	elif current_wedge["type"] == WheelConfig.wedge_type.JOKER:
		AudioManager.play(AudioManager.BusID.EFFECT, GameData.AudioID.JOKER)
		current_player.jokers += 1
	
		

func _on_spin():
	info_box.clear_line(2)
	var random_spin = randf_range(WheelConfig.min_spin, WheelConfig.max_spin)
	wheel.start_spin(random_spin)
	info_box.set_button_states(false)

func _on_vokal():
	info_box.set_button_states(false)
	input_panel.set_state(InputPanel.InputPanelState.VOCAL)
	input_panel.show_panel(true)
	current_player.balance -= GameData.vocal_cost
	player_panel.players_containers[current_player.number-1].set_balance(current_player.balance)

func _on_guess():
	info_box.set_button_states(false)
	input_panel.set_state(InputPanel.InputPanelState.FULLWORD)
	input_panel.show_panel(true)
