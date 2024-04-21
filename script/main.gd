extends Node

# 使用 @export var mob_scene: PackedScene 来允许我们选择要实例化的 Mob 场景
@export var mob_scene: PackedScene
# 初始概率为 10%
@export var initialItemSpawnProbability: float = 0.5

var score
# 将 itemSpawnProbability 的初始值设置为一个变量
@export var itemSpawnProbability: float = 0.5

# 当节点第一次进入场景树时调用。
func _ready():
	pass

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
	print("StartTimer.start")
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
	print("start_timer_timeout")
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

	# 通过将其添加到主场景来生成生物。
	add_child(mob)
	
#在 _on_mob_timer_timeout() 中， 我们先创建小怪实例，然后沿着 Path2D 路径随机选取起始位置
#最后让小怪移动。PathFollow2D 节点将沿路径移动，并会自动旋转，所以我们将使用它来选择怪物的方位
#和朝向。生成小怪后，我们会在 150.0 和 250.0 之间选取随机值，表示每只小怪的移动速度（如果它们
#都以相同的速度移动，那么就太无聊了）。
#注意，必须使用 add_child() 将新实例添加到场景中。

# 生成随机坐标的函数
func generateRandomCoordinateInRect(pos: Vector2, size: Vector2) -> Vector2:    
	var rect_min = pos   
	var rect_max = pos + size   
	var x = randf_range(rect_min.x, rect_max.x)    
	var y = randf_range(rect_min.y, rect_max.y)   
	var randomCoordinate = Vector2(x, y)   
	return randomCoordinate

# 生成道具
func generateAndSpawnItem():
	# 生成随机坐标
	var rectPosition = Vector2(0, 0)  # 矩形的左上角位置
	var rectSize = Vector2(480, 720)  # 矩形的大小
	var itemPosition = generateRandomCoordinateInRect(rectPosition, rectSize)
	
	# 实例化 Item 场景
	var itemScene = preload("res://scene/item.tscn").instantiate()
	
	# 设置 Item 的位置为随机坐标
	itemScene.position = itemPosition
	
	# 将 Item 添加到场景中
	add_child(itemScene)

# 在ItemTimer 计时结束时进行概率运算
func _on_item_timer_timeout():
	# 随机生成一个 0 到 1 之间的随机数
	var randomValue = randf()
	
	print("随机数",randomValue)
	# 如果随机数小于等于当前概率，则生成道具
	if randomValue <= itemSpawnProbability:
		generateAndSpawnItem()
		 # 重置概率为初始值，确保下次计时结束时重新开始
		print("T")
		itemSpawnProbability = initialItemSpawnProbability
		print("T itemSpawnProbability",itemSpawnProbability)
	else:
		# 否则增加概率
		itemSpawnProbability += 0.1
		print("F")
		print("F itemSpawnProbability",itemSpawnProbability)
