class_name Wheel extends Node

@export var wheel_node: Node2D  
signal spin_finished(index: int)
var rotation_speed: float = 0.0 # radians/s
var rotation_damp: float = 5.0 # radians/s
var start_rotation: float = 0.0
var end_rotation: float = 0.0
var spinning: bool = false

# for audio
var ticks_per_rotation: int = WheelConfig.wedges.size()
var _rotation_accum: float = 0.0  
var _last_tick_index: int = 0  

func _ready() -> void:    
	wheel_node.create_wedges()
	AudioManager.set_volume(AudioManager.BusID.EFFECT, -3.0) # - 3db

func start_spin(speed: float) -> void:
	rotation_speed = deg_to_rad(speed)
	start_rotation = wheel_node.rotation
	_rotation_accum = 0.0
	_last_tick_index = 0
	spinning = true

func _process(delta: float) -> void:
	if spinning:  
		# audio
		_rotation_accum += rotation_speed * delta  
		var rotation_per_tick = TAU / ticks_per_rotation
		var current_tick_index = int(_rotation_accum / rotation_per_tick)
		if current_tick_index != _last_tick_index:
			# AudioManager.stop(AudioManager.BusID.EFFECT)
			AudioManager.play(AudioManager.BusID.EFFECT, GameData.AudioID.WOF_TICK, AudioResource.Mode.ALL_VARIANT, true)
			_last_tick_index = current_tick_index
		# logic
		if rotation_speed <= 0.01:            
			rotation_speed = 0.0
			spinning = false
			end_rotation = wheel_node.rotation 
			AudioManager.stop(AudioManager.BusID.EFFECT, true)
			_on_spin_finished()
			return
		wheel_node.rotation += rotation_speed * delta
		rotation_speed -=  rotation_damp * delta
		

func _on_spin_finished() -> void:   
	var segments = WheelConfig.wedges.size()
	
	var needle_offset = PI / 2  # top
	
	var rotation_relative_to_needle = fposmod(end_rotation + needle_offset, TAU)
	var angle_step = TAU / segments
	
	var winner_index = int(floor(rotation_relative_to_needle / angle_step)) % segments    
	spin_finished.emit(winner_index)
