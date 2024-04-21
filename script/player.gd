extends Node2D
signal hit

@export var speed = 400 # @导出变量速度= 400 #
var speed_multiplier: float = 1
var screen_size # 游戏窗口的大小。

func _ready():
	# 查看游戏窗口大小
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	var velocity = Vector2.ZERO # 玩家的运动矢量。
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed * speed_multiplier
		$Area2D/AnimatedSprite2D.play() 
		# $ 是 get_node() 的简写。
		# 因此在上面的代码中，$AnimatedSprite2D.play() 与 get_node("AnimatedSprite2D").play() 相同。
	else:
		$Area2D/AnimatedSprite2D.stop()

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size) # clamp 一个值意味着将其限制在给定范围内
	
	if velocity.x != 0:
		$Area2D/AnimatedSprite2D.animation = "walk"
		$Area2D/AnimatedSprite2D.flip_v = false # 使用 flip_h 属性将这个动画进行水平翻转
		# See the note below about boolean assignment.
		$Area2D/AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$Area2D/AnimatedSprite2D.animation = "up"
		$Area2D/AnimatedSprite2D.flip_v = velocity.y > 0



func start(pos):
	position = pos
	show()
	$Area2D/CollisionShape2D.disabled = false

func _on_area_2d_body_entered(_body):
		hide() # 玩家被击中后消失。
		hit.emit()
		# 必须推迟，因为我们无法在物理回调上更改物理属性。
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
