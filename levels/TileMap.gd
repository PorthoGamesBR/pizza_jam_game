extends TileMap

var rng = RandomNumberGenerator.new()
var mapHeight = 32
var mapWidth = 32

func _ready():
	for x in range(mapHeight):
		for y in range(mapWidth):
			var random = rng.randf_range(0, 450)
			var final = Vector2(0,0)
			if random>325:
				final = Vector2(1,0)
			if random>350:
				final = Vector2(2,0)
			if random>375:
				final = Vector2(2,1)
			if random>400:
				final = Vector2(1,1)
			if random>424:
				final = Vector2(0,1)
			if random>425:
				final = Vector2(3,0)
			if random>432:
				final = Vector2(4,0)
			if random>435:
				final = Vector2(3,1)
			if random>438:
				final = Vector2(4,1)
			set_cell(0,Vector2i(x-mapWidth/2,y-mapHeight/2),0,final)
		


func _process(delta):
	pass
