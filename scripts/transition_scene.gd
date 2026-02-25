class_name TransitionScene extends Control

@export var progression_bar : ProgressBar

var wait_time: float = 1.0
var timer: Timer
var elapsed_time :float = 0.0

func _ready(): 
	progression_bar.max_value = wait_time
	progression_bar.min_value = 0.0
	elapsed_time = 0.0
	timer = Timer.new()
	timer.wait_time = wait_time  
	timer.one_shot = true
	add_child(timer)
	timer.start()
	timer.connect("timeout", Callable(self, "_on_timeout"))

func _process(delta: float) -> void:
	elapsed_time += delta
	progression_bar.value = elapsed_time

func _on_timeout():
	GameData.Scenes.switch_to(GameData.Scenes.in_game)
	
	
