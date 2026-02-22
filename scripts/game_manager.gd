extends Node

@export var wheel : Wheel
@export var info_box : InfoBox
@export var input_panel : InputPanel
@export var player_panel: PlayerPanel
@export var round_label: Label
@export var category_label: Label
@export var letter_grid : LetterGrid
@export var yes_no_modal: YesNoModal


@onready var current_player_id: int = GameData.players.size()-1
var current_player : Player
var current_round : int = 0
var winner : Player
var current_wedge: Dictionary

var listen_input := false


func _ready():
	wheel.spin_finished.connect(_on_wheel_finished)
	# info_box.connect("line_done", Callable(self, "_on_line_done"))
	# info_box.connect("all_done", Callable(self, "_on_all_done"))
	info_box.connect("on_spin", Callable(self, "_on_spin"))
	info_box.connect("on_vokal", Callable(self, "_on_vokal"))
	info_box.connect("on_guess", Callable(self, "_on_guess"))
	input_panel.connect("on_submit",Callable(self,"_on_input_submit"))
	yes_no_modal.connect("on_button",Callable(self,"_on_modal"))

	input_panel.show_panel(false)

	_setup_game()

func _setup_game():
	current_player = GameData.players[current_player_id]
	_reset_round()
	

func _reset_round():
	listen_input = false
	var cat = GameData.categories.get_random_category()
	letter_grid.setup_category(cat)
	category_label.text = "Kategori: " + cat.name
	
	current_round += 1
	round_label.text = "Runde: " + str(current_round)
	if current_round > GameData.n_rounds:
		# games done
		info_box.clear_text()
		info_box.show_text("Spillet er slut!",1)		
		info_box.set_button_states(false)
		winner = null
		for player in GameData.players:
			if winner == null:
				winner = player
			elif player.balance > winner.balance:
				winner = player
		
		var player_text = "[color=%s]%s[/color] vand spilled med: %d Kr" % [GameData.get_color_string(winner.color), winner.name, winner.balance]
		info_box.show_text(player_text,2)	
		return
	
	_next_player()
	_start_turn()

func _next_player():
	for player in player_panel.players_containers:
		player.set_active(false)
	current_player_id = (current_player_id + 1) % GameData.players.size()
	current_player = GameData.players[current_player_id]
	info_box.set_button_states(true)
	
		

func _start_turn():
	player_panel.players_containers[current_player.number-1].set_active(true)

	var player_text = "[color=%s]%s[/color]'s tur" % [GameData.get_color_string(current_player.color), current_player.name]
	info_box.clear_line(1)
	info_box.clear_line(2)
	info_box.clear_line(3)
	info_box.show_text(player_text,1)
	info_box.set_button_states(true)

	if current_player.balance >= 500:
		info_box.set_button_state(1, true)
	else:
		info_box.set_button_state(1, false)

func _end_turn()-> bool:
	if letter_grid.is_solved():
		current_player.balance += GameData.round_bonus
		player_panel.players_containers[current_player.number-1].set_balance(current_player.balance)
		info_box.clear_line(2)
		info_box.clear_line(3)
		var text = "[color=%s]%s[/color] vandt runden" % [GameData.get_color_string(current_player.color), current_player.name]
		info_box.show_text(text, 2)
		info_box.show_text("Tryk enter for at starte næste runde", 3)
		listen_input = true
		info_box.set_button_states(false)
		print("solved")
		return true
	else:
		print("not solved")
		return false
	
		

# Events/callbacks

func _on_modal(button: YesNoModal.ButtonID):
	
	if button == YesNoModal.ButtonID.YES:		
		current_player.jokers = clamp(current_player.jokers - 1, 0, 999)		
		yes_no_modal.show_modal(false)
		info_box.set_button_states(true)
	
	elif button == YesNoModal.ButtonID.NO:
		yes_no_modal.show_modal(false)
		_next_player()
		_start_turn()
	

	
	


func _input(event):
	if not listen_input:
		return

	if event.is_action_pressed("ui_accept"):
		_reset_round()

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
		if current_player.jokers > 0:
			input_panel.focus_locked = false
			yes_no_modal.set_joker(current_player.jokers)
			yes_no_modal.show_modal(true)
		else:
			_next_player()
			
	_start_turn()

func _on_wheel_finished(index):
	current_wedge = WheelConfig.wedges[index]
	var text = WheelConfig.wedge_element_to_str(current_wedge)	
	info_box.show_text(text, 2)
	info_box.set_button_states(true)

	if current_wedge["type"] == WheelConfig.wedge_type.NORMAL:
		
		info_box.set_button_states(false)
		info_box.show_text("Gæt en konsonant", 3)
		input_panel.set_state(InputPanel.InputPanelState.CONSONANT)
		input_panel.show_panel(true)
		# input_box.
	elif current_wedge["type"] == WheelConfig.wedge_type.BANKRUPT:
		current_player.balance = 0
		player_panel.players_containers[current_player.number-1].set_balance(current_player.balance)
		_end_turn()
		_next_player()
		_start_turn()

	elif current_wedge["type"] == WheelConfig.wedge_type.LOSE_TURN:
		_end_turn()
		_next_player()
		_start_turn()
	
	elif current_wedge["type"] == WheelConfig.wedge_type.JOKER:
		current_player.jokers += 1

# func _on_line_done(line):
# 	print("Line finished:", line)

# func _on_all_done():
# 	print("All lines finished!")

func _on_spin():
	info_box.clear_line(2)
	var random_spin = randf_range(WheelConfig.min_spin, WheelConfig.max_spin)
	wheel.start_spin(random_spin)
	info_box.set_button_states(false)

func _on_vokal():
	info_box.set_button_states(false)
	input_panel.set_state(InputPanel.InputPanelState.VOCAL)
	input_panel.show_panel(true)
	current_player.balance -= 500
	player_panel.players_containers[current_player.number-1].set_balance(current_player.balance)

func _on_guess():
	info_box.set_button_states(false)
	input_panel.set_state(InputPanel.InputPanelState.FULLWORD)
	input_panel.show_panel(true)
