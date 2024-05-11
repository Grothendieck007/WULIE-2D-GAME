extends RigidBody2D


func _ready():
	# AnimatedSprite2D 的 sprite_frames 属性中获取动画名称的列表。
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	
	# randi() % n 会在 0 and n-1 之中选择一个随机整数.
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])
	
# 怪物退出屏幕后清除
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

