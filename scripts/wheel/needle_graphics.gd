extends Node2D
@export var polygon: Polygon2D

func _ready():
    polygon.polygon = PackedVector2Array([
        Vector2(0, -WheelConfig.radius + 20),   # tip at bottom
        Vector2(-10, -WheelConfig.radius - 10), # left base
        Vector2(10, -WheelConfig.radius - 10)   # right base
    ])
    polygon.color = Color.WHITE
    polygon.z_index = 11

