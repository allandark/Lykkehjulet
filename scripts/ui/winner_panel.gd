class_name WinnerPanel extends TextureRect

@export var particle_system: GPUParticles2D
@export var label: RichTextLabel

# func _ready() -> void:
# 	# particle_system.emitting = true
# 	# var player = Player.new("test spiller", 0, Color.RED, 0)
# 	# set_winner_text(player)
# 	pass


func show_panel(value: bool):
	visible = value

func set_winner_text(player: Player):
	label.text = "%s vandt spillet med %d Kr" % [player.name, player.balance]
