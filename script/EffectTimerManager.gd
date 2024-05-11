extends Node
var EffectSystem: Node
var effect_timer: NodePath

var effect_timer_map = {
	"SpeedEffect": "SpeedEffectTimer",
}

var EffectSystemScene = preload("res://scene/effect_system.tscn").instantiate()

func _ready():
	add_child(EffectSystemScene)
	
func _on_effect_on_signal_received(effect_type: String):
	if effect_type in effect_timer_map:
		effect_timer = effect_timer_map[effect_type]
		get_node(effect_timer).apply_signal()
	
	print("收到信号")
	print("effect_timer的值为",effect_timer)
	
	

