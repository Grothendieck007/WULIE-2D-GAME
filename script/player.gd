extends Node2D
signal hit

@export var speed = 400 # @导出变量速度= 400 #
var speed_multiplier: float = 1
var screen_size # 游戏窗口的大小。

func _ready():
	# 查看游戏窗口大小
	screen_size = get_viewport_rect().size
	hide()
	$Area2D/PlayerAnimatedSprite2D/SpeedEffectParticles2D.hide()

func _process(delta):
	# 玩家的运动矢量
	var velocity = Vector2.ZERO
	
	var speed_effect_particles2d = $Area2D/PlayerAnimatedSprite2D/SpeedEffectParticles2D
	var player_animated_sprite2d = $Area2D/PlayerAnimatedSprite2D
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		# 通过修改重力的x，y值改变尾迹方向
		speed_effect_particles2d.gravity.x = -90
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		speed_effect_particles2d.gravity.x = 90
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		speed_effect_particles2d.gravity.y = -100
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		speed_effect_particles2d.gravity.y = 100

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed * speed_multiplier
		player_animated_sprite2d.play() 
		# $ 是 get_node() 的简写。
		# 因此在上面的代码中，$AnimatedSprite2D.play() 与 get_node("AnimatedSprite2D").play() 相同。
	else:
		player_animated_sprite2d.stop()
		speed_effect_particles2d.gravity.x = 0

	position += velocity * delta
	# clamp 一个值意味着将其限制在给定范围内
	position = position.clamp(Vector2.ZERO, screen_size) 
	
	if velocity.x != 0:
		player_animated_sprite2d.animation = "walk"
		# 布尔值flip_v 如果为 true，纹理将被垂直翻转。
		player_animated_sprite2d.flip_v = false 
		# 布尔值flip_h 如果为 true，纹理将被水平翻转。
		player_animated_sprite2d.flip_h = velocity.x < 0
	elif velocity.y != 0:
		player_animated_sprite2d.animation = "up"
		player_animated_sprite2d.flip_v = velocity.y > 0



func start(pos):
	position = pos
	show()
	$Area2D/CollisionShape2D.disabled = false

func _on_area_2d_body_entered(_body):
		hide() # 玩家被击中后消失。
		hit.emit()
		# 必须推迟，因为我们无法在物理回调上更改物理属性。
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
