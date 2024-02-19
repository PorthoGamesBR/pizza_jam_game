extends TileMap
var chance = [[325,25,25,3,3],[1, 25, 25, 3,12]]
var rng = RandomNumberGenerator.new()
var mapHeight = 32
var mapWidth = 32

func _ready():
	var total = 0
	for x in chance:
		for y in x:
			total+=y
	for x in range(mapHeight):
		for y in range(mapWidth):
			var random = rng.randf_range(0, total)
			var final = getVector(random)
			set_cell(0,Vector2i(x-mapWidth/2,y-mapHeight/2),0,final)
		

func _process(delta):
	pass

func getVector(val):
	var y = 0
	var total=0
	for array in chance:
		var x = 0
		for value in array:
			if(val<total+value):
				return Vector2(x,y)
			x+=1
			total+=value
		y+=1
	return Vector2(0,0)
