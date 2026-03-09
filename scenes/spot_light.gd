class_name SpotLight extends PointLight2D

var energy_time: float = 5.0

var radius = 100.0
var speed = 1.0
var pos_offset: Vector2

func _ready() -> void:
	var tween = create_tween().set_loops()
	tween.parallel() 
	tween.tween_property(self, "energy", 1.5, energy_time)
	tween.tween_property(self, "energy", 0.5, energy_time)	
	tween.tween_property(self, "color", Color.YELLOW, energy_time)
	tween.tween_property(self, "color", Color.RED, energy_time)
	pos_offset = position


func _process(_delta):
	var angle = Time.get_ticks_msec() / 1000.0 * speed
	position = Vector2(cos(angle), sin(angle*0.5)) * radius + pos_offset