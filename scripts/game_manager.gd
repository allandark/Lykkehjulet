extends Node

@export var wheel : Node2D
@export var info_box : ColorRect


func _ready():
	wheel.spin_finished.connect(_on_wheel_finished)
	info_box.connect("line_done", Callable(self, "_on_line_done"))
	info_box.connect("all_done", Callable(self, "_on_all_done"))
	info_box.connect("on_spin", Callable(self, "_on_spin"))
	info_box.connect("on_vokal", Callable(self, "_on_vokal"))
	info_box.connect("on_guess", Callable(self, "_on_guess"))


	
# Events/callbacks


func _on_wheel_finished(index):
	var winner_data = WheelConfig.wedges[index]
	var text = WheelConfig.wedge_element_to_str(winner_data)	
	info_box.show_text(text, 2)
	info_box.set_button_state(true)


func _on_line_done(line):
		print("Line finished:", line)

func _on_all_done():
		print("All lines finished!")

func _on_spin():		
		info_box.show_text("[color=blue]Player1[/color]'s tur",1)
		info_box.clear_line(2)
		var random_spin = randf_range(WheelConfig.min_spin, WheelConfig.max_spin)
		wheel.start_spin(random_spin)
		info_box.set_button_state(false)

func _on_vokal():
		print("vokal")

func _on_guess():
		print("vokal")
