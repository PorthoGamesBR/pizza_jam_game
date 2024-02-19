extends TileMap

var rng = RandomNumberGenerator.new()
var mapHeight = 32
var mapWidth = 32

func _ready():
	for x in range(mapHeight):
		for y in range(mapWidth):
			var random = rng.randf_range(0, 200)
			var final = Vector2(0,0)
			if random>100:
				final = Vector2(1,0)
			if random>125:
				final = Vector2(2,0)
			if random>150:
				final = Vector2(2,1)
			if random>175:
				final = Vector2(1,1)
			if random>198:
				final = Vector2(0,1)
			set_cell(0,Vector2i(x-mapWidth/2,y-mapHeight/2),0,final)
		


func _process(delta):
	pass
