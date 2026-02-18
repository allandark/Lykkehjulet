extends Node

@export var wheel_node: Node2D  # assign the spinning WheelNode here
signal spin_finished(index: int)
var rotation_speed: float = 0.0 # radians/s
var rotation_damp: float = 5.0 # radians
var start_rotation: float = 0.0
var end_rotation: float = 0.0
var spinning: bool = false

func _ready() -> void:    
    wheel_node.create_wedges()

func start_spin(speed: float) -> void:
    rotation_speed = deg_to_rad(speed)
    start_rotation = wheel_node.rotation
    spinning = true

func _process(delta: float) -> void:
    if spinning:                
        if rotation_speed <= 0.01:            
            rotation_speed = 0.0
            spinning = false
            _on_spin_finished()
            return
        wheel_node.rotation += rotation_speed * delta
        rotation_speed -=  rotation_damp * delta
        

func _on_spin_finished() -> void:   
    var segments = WheelConfig.wedges.size()
    end_rotation = wheel_node.rotation
     # Needle points at top (Godot y-axis up is -PI/2 radians)
    var needle_offset = PI / 2  # top

    # Calculate the wheel rotation relative to the needle
    var rotation_relative_to_needle = fposmod(end_rotation + needle_offset, TAU)
    var angle_step = TAU / segments
    # Determine which wedge the needle is over
    var winner_index = int(floor(rotation_relative_to_needle / angle_step)) % segments
    print("Winner index:", winner_index)
    spin_finished.emit(winner_index)