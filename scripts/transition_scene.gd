class_name TransitionScene extends Control

@export var progression_bar : ProgressBar
@export var debug_label: Label

@export var title_rect: TextureRect
@export var letter_grid: LetterGrid
@export var wheel: Wheel

var wait_time: float = 47.0
var running_timer: Timer
var elapsed_time :float = 0.0

var hold_timer: Timer
var hold_elapsed_time :float = 0.0
var hold_wait_time: float = 1.0
var key_held: bool = false

var timeline = [
		{"time": 2.0, "action": func(): fade_in(title_rect, 2.0)},
		{"time": 7.5, "action": func(): fade_in(letter_grid, 2.0)},
		{"time": 10.0, "action": func(): setup_letter()},
		{"time": 11.0, "action": func(): guess_letter("R")},
		{"time": 12.0, "action": func(): guess_letter("B")},
		{"time": 13.5, "action": func(): guess_letter("T")},
		{"time": 15.5, "action": func(): guess_letter("E")},
		{"time": 16.5, "action": func(): guess_letter("G")},
		{"time": 17.5, "action": func(): guess_letter("R")},
		{"time": 18.5, "action": func(): guess_letter("A")},
		{"time": 19.5, "action": func(): guess_letter("R")},
		{"time": 20.5, "action": func(): guess_letter("S")},
		{"time": 21.5, "action": func(): guess_letter("L")},
		{"time": 22.5, "action": func(): guess_letter("R")},
		{"time": 23.5, "action": func(): guess_letter("P")},
		{"time": 24.5, "action": func(): guess_letter("F")},
		{"time": 25.5, "action": func(): guess_letter("Å")},
		{"time": 24.5, "action": func(): guess_letter("N")},
		{"time": 28.5, "action": func(): guess_letter("T")},
		{"time": 28.5, "action": func(): guess_letter("O")},

		{"time": 30.0, "action": func(): fade_out(letter_grid, 2.0)},
		{"time": 32.0, "action": func(): fade_in(wheel, 2.0)},
		{"time": 35.0, "action": func(): spin(wheel, 360*20.0)},
		{"time": 40.0, "action": func(): move_to(wheel, Vector2(400, 680), 10)},
		
]
var current_event = 0

var cat: Category = Category.new("Intro", ["Slanger på fortet"])

func _ready(): 
	AudioManager.on_audio_finished.connect(_on_audio_finished)
	AudioManager.on_fade_finished.connect(_on_audio_fade_finished)

	AudioManager.set_volume(AudioManager.BusID.EFFECT, -24)

	progression_bar.max_value = hold_wait_time
	progression_bar.min_value = 0.0

	elapsed_time = 0.0
	running_timer = Timer.new()
	running_timer.wait_time = wait_time  
	running_timer.one_shot = true
	add_child(running_timer)
	running_timer.start()
	reset_timeline()	

	hold_timer = Timer.new()
	hold_timer.one_shot = true
	hold_timer.wait_time = hold_wait_time  
	add_child(hold_timer)
	hold_timer.timeout.connect(_on_hold_timeout)
	
	AudioManager.play(AudioManager.BusID.BACKGROUND, GameData.AudioID.THEME_SONG_SHORT)

func _process(delta: float) -> void:
	elapsed_time += delta	
	debug_label.text = "%.2f" % elapsed_time

	if current_event < timeline.size() and elapsed_time >= timeline[current_event]["time"]:
		timeline[current_event]["action"].call_deferred()
		current_event += 1

	if key_held:
		progression_bar.visible = true 
		hold_elapsed_time += delta
		progression_bar.value = hold_elapsed_time
	else:
		progression_bar.visible = false


	
func _on_hold_timeout():	
	AudioManager.fade_volume(AudioManager.BusID.BACKGROUND, -60, 0.5)
	
func _input(event):
	if event.is_action_pressed("skip_keys"): 
			key_held = true
			hold_timer.start()
			hold_elapsed_time = 0.0
	elif event.is_action_released("skip_keys"):
			key_held = false
			hold_timer.stop()


func _on_audio_fade_finished(_bus: AudioManager.BusID):
	AudioManager.set_volume(AudioManager.BusID.BACKGROUND, 0)
	AudioManager.stop(AudioManager.BusID.BACKGROUND)
	GameData.Scenes.switch_to(GameData.Scenes.in_game)

func _on_audio_finished(_bus: AudioManager.BusID):	
	# AudioManager.set_volume(AudioManager.BusID.BACKGROUND, 0.0)
	GameData.Scenes.switch_to(GameData.Scenes.in_game)

func reset_timeline():
	elapsed_time = 0.0
	current_event = 0

func fade_in(node: Node,  duration: float):
	node.modulate.a = 0
	node.visible = true
	var tween = create_tween()
	tween.tween_property(node, "modulate:a", 1.0, duration)

func fade_out(node: Node,  duration: float):
	var tween = create_tween()
	tween.tween_property(node, "modulate:a", 0.0, duration)

func move_to(node: Node,  _position: Vector2,  duration: float):
	var tween = create_tween()
	tween.tween_property(node, "position", _position, duration)
	
func pulse_light(light: SpotLight, duration: float):
	var tween = create_tween().set_loops()
	tween.tween_property(light, "energy", 2.0, duration)
	tween.tween_property(light, "energy", 0.5, duration)

func spin(node: Wheel,  degrees: float):
	node.start_spin(degrees)

func setup_letter():
	letter_grid.setup_category(cat)

func guess_letter(letter: String):
	if letter in GameData.vocals:
		letter_grid.guess_vocal(letter)
	elif letter in GameData.consonants:
		letter_grid.guess_consonant(letter)
	else:
		print("wrong guess")
