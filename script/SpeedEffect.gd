extends Node

@export var speed_multiplier: float = 1.0 #速度乘数

@export var speed_effect_duration: float = 3.0 #速度效果生效时间

signal speed_effect_off

var player
var timer


#效果生效
func apply_effect():
	speed_multiplier = 2.0
	$Timer.start()
	if $Timer.is_stopped():
		print("定时器已停止")
	else:
		print("定时器正在运行")
	_change_player_speed_multiplier()
	

func _change_player_speed_multiplier():
	#父节点 ES 父父节点 Item 父父父节点 Main
	player = $"../../../Player"
	print("player", player)
	player.speed_multiplier = speed_multiplier
	print("玩家速度 ",player.speed_multiplier)

func _on_timer_timeout():
	print("触发timeout")
	speed_multiplier = 1.0
	_change_player_speed_multiplier()
	print("重置玩家速度",player.speed_multiplier)
	speed_effect_off.emit()
 
