extends Node
#效果编号
@export var effect_index: int = 1
#速度乘数
@export var speed_multiplier: float = 1.0
#速度效果生效时间
@export var speed_effect_duration: float = 2.0
#时间
var speed_effect_timer: Timer

func _ready():
	speed_effect_timer = $Timer
	randomize()

#效果生效
func apply_speed_effect():
	speed_multiplier = 2.0
	speed_effect_timer.start(speed_effect_duration)

#删除效果
func cancel_speed_effect():
	speed_multiplier = 1.0


func _on_Timer_timeout():
	cancel_speed_effect()
