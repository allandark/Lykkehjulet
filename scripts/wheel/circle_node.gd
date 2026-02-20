extends Node2D


@onready var outer_radius := WheelConfig.outer_circle_radius
@onready var inner_radius := WheelConfig.inner_circle_radius

func _draw():
    draw_circle(Vector2.ZERO, outer_radius, Color(0.3,0.3,0.3))  # gray
    draw_circle(Vector2.ZERO, inner_radius, Color(0.8,0.8,0.8))  # light gray