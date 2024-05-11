extends Node

# 爆炸效果节点
var explosion01
var explosion02
var explosion_area

# 怪物节点
var mob


# 运行效果方法
func apply_effect():
	
	# 读取节点
	explosion01 = $ExplosionParticles01
	explosion02 = $ExplosionParticles01/ExplosionParticles02
	explosion_area = $ExplosionParticles01/ExplosionParticles02/Area2D
	
	# 确定爆炸效果1的位置
	explosion01.position = $"../..".item_position
	
	# 启动爆炸效果粒子效果
	explosion01.restart()
	explosion02.restart()
	
	# 启动爆炸范围监测
	explosion_area.monitoring = true
	await get_tree().create_timer(0.5).timeout
	explosion_area.monitoring = false
	
	
	# 等待粒子效果结束
	await explosion01.finished
	await explosion02.finished



func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.is_in_group("mob"):
		body.queue_free()
	
	


func _on_area_2d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	var parent
	parent = area.get_parent()
	if parent.is_in_group("item"):
		parent.queue_free()
