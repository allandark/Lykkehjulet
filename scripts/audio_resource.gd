class_name AudioResource extends Resource

enum Mode {
	SINGLE_VARIANT,
	ALL_VARIANT,
	LOOP_VARIANT
}

@export var streams: Array[AudioStream] = []  
var current_index: int = 0 
var mode : Mode = Mode.ALL_VARIANT
var fade_in_time: float = 0.0
var fade_out_time: float = 0.0
var finish_current_loop: bool = false
var use_random_variant: bool = false
var play_all: bool = true # for ALL_VARIANT mode


func reset_for_play():
	finish_current_loop = false
	use_random_variant = false
	play_all = true
	fade_in_time = 0.0
	
