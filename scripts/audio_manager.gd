extends Node

@export var bg_audio_player : AudioStreamPlayer
@export var effect_audio_player : AudioStreamPlayer
@export var audio_resources: Array[AudioResource]

var using_effect_a: bool = true
var using_bg_a: bool = true
var current_effect_audio: AudioResource
var current_background_audio: AudioResource
var fade_time = 0.05

enum BusID {
	EFFECT,
	BACKGROUND
}


signal on_audio_finished(bus: BusID)
signal on_fade_finished(bus: BusID)
# signal sound_looped(bus: BusID, sound_id: AudioID)

func _ready() -> void:  
	bg_audio_player.finished.connect(_bg_audio_finished)	
	effect_audio_player.finished.connect(_effect_audio_finished)



func get_resource(audio_id: int) -> AudioResource:
	return audio_resources.get(audio_id)

func get_current_playing(bus: BusID) -> AudioResource:
	if bus == BusID.EFFECT:
		if effect_audio_player.playing:
			return current_effect_audio
	elif bus == BusID.BACKGROUND:
		if bg_audio_player.playing:
			return current_background_audio
	return null

func play(
		bus: BusID, 
		sound_id: int, 
		mode: AudioResource.Mode = AudioResource.Mode.SINGLE_VARIANT, 
		current_index:int = 0, 
		use_random_variant: bool = false):

	audio_resources[sound_id].mode = mode
	audio_resources[sound_id].current_index = current_index
	audio_resources[sound_id].use_random_variant = use_random_variant
	if bus == BusID.EFFECT:		
		_configure_stream(audio_resources[sound_id], effect_audio_player)
		current_effect_audio = audio_resources[sound_id]
		effect_audio_player.play()
		
	elif bus == BusID.BACKGROUND:
		_configure_stream(audio_resources[sound_id], bg_audio_player)
		current_background_audio = audio_resources[sound_id]
		bg_audio_player.play()

func resume(bus: BusID):
	if bus == BusID.EFFECT:
		effect_audio_player.stream_paused = false

	elif bus == BusID.BACKGROUND:
		bg_audio_player.stream_paused = false
		
func pause(bus: BusID):
	if bus == BusID.EFFECT:
		effect_audio_player.stream_paused = true

	elif bus == BusID.BACKGROUND:		
		bg_audio_player.stream_paused = true


func stop(bus: BusID, instant: bool = false):
	if bus == BusID.EFFECT:
		if current_effect_audio:
			current_effect_audio.finish_current_loop = not instant
		_stop_audio(current_effect_audio, effect_audio_player)		
	

	elif bus == BusID.BACKGROUND:
		if current_background_audio:
			current_background_audio.finish_current_loop = not instant			
		_stop_audio(current_background_audio, bg_audio_player)
		

func stop_all():
	effect_audio_player.stop()
	bg_audio_player.stop()
	
func is_playing(bus: BusID) -> bool:
	if bus == BusID.EFFECT:
		return effect_audio_player.playing

	elif bus == BusID.BACKGROUND:	
		return bg_audio_player.playing
	return false

func set_volume(bus: BusID, value_db: float):
	if bus == BusID.EFFECT:
		effect_audio_player.volume_db = value_db
	elif bus == BusID.BACKGROUND:
		bg_audio_player.volume_db = value_db	


func fade_volume(bus: BusID, target_db: float, duration: float) -> void:
	var player: AudioStreamPlayer
	match bus:
		BusID.EFFECT:
			player = effect_audio_player
		BusID.BACKGROUND:
			player = bg_audio_player

	await _fade_volume(player, target_db, duration)
	emit_signal("on_fade_finished", bus)

func _configure_stream(audio_res: AudioResource, player: AudioStreamPlayer) -> void:
	audio_res.reset_for_play()
	var index =  clamp(audio_res.current_index, 0, audio_res.streams.size() - 1)
	player.stream = audio_res.streams[index]
	match audio_res.mode:
		AudioResource.Mode.SINGLE_VARIANT:
			pass
		AudioResource.Mode.ALL_VARIANT:
			if audio_res.use_random_variant:
				index = randi() % audio_res.streams.size()
			else:
				audio_res.current_index = (audio_res.current_index + 1) % audio_res.streams.size()
				index = audio_res.current_index
				audio_res.streams[index].loop = false			

		AudioResource.Mode.LOOP_VARIANT:						
			player.stream.loop = true

	

func _stop_audio(audio_res: AudioResource, player: AudioStreamPlayer) -> void:
	if audio_res: 
		if audio_res.finish_current_loop and player.stream.loop:
				# Wait until current loop finishes
				var remaining = player.stream.get_length() - player.get_playback_position()
				await get_tree().create_timer(remaining).timeout

		if audio_res.finish_current_loop and audio_res.fade_out_time > 0:
				_fade_volume(player, -80, audio_res.fade_out_time)
				await get_tree().create_timer(audio_res.fade_out_time).timeout

	player.stop()

func _fade_volume(player: AudioStreamPlayer, target_db: float, duration: float) -> void:
	var start_db = player.volume_db
	var t = 0.0
	while t < duration:
			t += get_process_delta_time()
			player.volume_db = lerp(start_db, target_db, t / duration)
			await get_tree().process_frame
	player.volume_db = target_db



func _bg_audio_finished():  
	_on_audio_finished(BusID.BACKGROUND)

func _effect_audio_finished():  
	_on_audio_finished(BusID.EFFECT)

func _on_audio_finished(bus: BusID):
	emit_signal("on_audio_finished", bus)
