extends Timer
var speed_effect: Node
var speed_effect_particle: Node

func _ready():
	speed_effect_particle = get_node("../../Player/Area2D/PlayerAnimatedSprite2D/SpeedEffectParticles2D")
	print("speed_effect_particle为",speed_effect_particle)

func apply_signal():
	speed_effect = get_node("../EffectSystem/SpeedEffect")
	
	print("speed_effect =",speed_effect)
	if is_stopped():
		start()
		speed_effect_particle.show()
	else:
		start(2)
		speed_effect_particle.show()

func _on_timeout():
	print("加速时间耗尽")
	speed_effect.speed_effect_timeout()
	speed_effect_particle.hide()
