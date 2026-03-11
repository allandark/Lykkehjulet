class_name PlayerJingle

var audio_id: GameData.AudioID 
var taken: bool
var label: String

func _init(_audio: GameData.AudioID, _label: String):
  audio_id = _audio  
  taken = false
  label = _label