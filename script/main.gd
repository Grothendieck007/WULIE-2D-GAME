extends Node

# 选择要实例化的 Mob 场景
@export var mob_scene: PackedScene

# 道具生成概率
@export var itemSpawnProbability: float = 0.5

# 道具生成初始概率
@export var initialItemSpawnProbability: float = 0.5

#得分
var score

# 道具生成系统
var item_generation_system

# 当节点第一次进入场景树时调用。
func _ready():
	item_generation_system = $ItemGenerationSystem

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$ItemTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$ItemTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("准备好！")
	get_tree().call_group("mobs", "queue_free")
	$Music.play()

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_mob_timer_timeout():
	# 创建 Mob 场景的新实例。
	var mob = mob_scene.instantiate()

	# 在 Path2D 上选择一个随机位置。
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# 将生物的方向设置为垂直于路径方向。
	var direction = mob_spawn_location.rotation + PI / 2

	# 将生物的位置设置为随机位置。
	mob.position = mob_spawn_location.position

	# 为方向添加一些随机性。
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# 选择生物的速度。
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# 将生成的怪物添加到组 mob
	mob.add_to_group("mob")

	# 通过将其添加到主场景来生成生物。
	add_child(mob)
	
# 先创建小怪实例，然后沿着 Path2D 路径随机选取起始位置
# 让小怪移动。PathFollow2D 节点将沿路径移动，并会自动旋转，所以我们将使用它来选择怪物的方位和朝向。
# 生成小怪后，我们会在 150.0 和 250.0 之间选取随机值，表示每只小怪的移动速度

# 生成随机坐标的函数
# 这个函数接收两个Vector2类型的参数：pos（矩形的左上角位置）和size（矩形的大小）
# 它返回一个Vector2类型的值，表示在矩形区域内的一个随机坐标
func generateRandomCoordinateInRect(pos: Vector2, size: Vector2) -> Vector2:    
	# 计算矩形的最小坐标（左上角）
	var rect_min = pos   
	 # 计算矩形的最大坐标（右下角）
	var rect_max = pos + size
	# 在矩形的x轴范围内生成一个随机数
	var x = randf_range(rect_min.x, rect_max.x)
	# 在矩形的y轴范围内生成一个随机数
	var y = randf_range(rect_min.y, rect_max.y)   
	# 创建一个新的Vector2，其坐标为(x, y)
	var randomCoordinate = Vector2(x, y)   
	# 返回这个随机坐标
	return randomCoordinate

# 生成道具
func generateAndSpawnItem():
	
	# 生成随机坐标
	var rectPosition = Vector2(0, 0)  # 矩形的左上角位置
	var rectSize = Vector2(480, 720)  # 矩形的大小
	
	# 传入道具位置
	item_generation_system.item_position = generateRandomCoordinateInRect(rectPosition, rectSize)
	print("item_generation_system.item_position = ",item_generation_system.item_position)
	
	# 调用方法生成道具
	item_generation_system.generation_item()

# 在ItemTimer 计时结束时进行概率运算
func _on_item_timer_timeout():
	
	# 随机生成一个 0 到 1 之间的随机数
	var randomValue = randf()
	
	print("随机数",randomValue)
	
	# 如果随机数小于等于当前概率，则生成道具
	if randomValue <= itemSpawnProbability:
		generateAndSpawnItem()
		
		 # 重置概率为初始值，确保下次计时结束时重新开始
		itemSpawnProbability = initialItemSpawnProbability
		
		print("成功生成 itemSpawnProbability为",itemSpawnProbability)
		
	else:
		# 否则增加概率
		itemSpawnProbability += 0.1
		print("没有生成 itemSpawnProbability为",itemSpawnProbability)
