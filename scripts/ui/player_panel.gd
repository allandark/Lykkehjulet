class_name PlayerPanel extends Node

@export var players_containers : Array[Node]

@export var player_container: PackedScene
@export var vbox: VBoxContainer

func _ready() -> void:
	
	for player in GameData.players:
		var instance = player_container.instantiate()
		instance.set_player_name(player.name)
		instance.set_balance(player.balance)
		instance.player_color = player.color
		instance.set_active(false)
		vbox.add_child(instance)
		players_containers.append(instance)
	



