extends TileMap
@export var mapHeight : int = 32
@export var mapWidth : int = 32
var chance : Array[Array] = [[325,25,25,3,3],[1, 25, 25, 3,12]]
var structure: Array[PhysicalStructure] = []
var rng = RandomNumberGenerator.new()

func populateStructure():
	var smallTree = PhysicalStructure.new(1, "SmallTree", 5, 3, 2)
	var bigTree = PhysicalStructure.new(2, "BigTree", 5, 3, 2)
	structure.append(smallTree)
	structure.append(bigTree)

func _ready():
	var total = 0
	for x in chance:
		for y in x:
			total+=y
	for x in range(mapHeight):
		for y in range(mapWidth):
			if get_cell_source_id(0,Vector2(x,y)) == -1:
				var random = rng.randf_range(0, total)
				var final = getAtlasId(random)
				set_cell(0,Vector2i(x-mapWidth/2,y-mapHeight/2),0,final)
	populateStructure()
	for struct in structure:
		generateStructure(struct)
		

func _process(_delta):
	pass

func getAtlasId(val):
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
	
func generateStructure(struct: PhysicalStructure):
	for i in range(struct.qtd):
		var created = false
		while(!created):
			var baseX = rng.randf_range(0, mapWidth-struct.width)-mapWidth/2
			var baseY = rng.randf_range(0, mapHeight-struct.height)-mapHeight/2
			if(verifyStructureConstruct(struct, baseX,baseY)):
				created = true
				setStructure(struct, baseX, baseY)
			
func verifyStructureConstruct(struct: PhysicalStructure, baseX:int, baseY:int):
	for x in range(struct.width):
		for y in range(struct.height):
			if !get_cell_source_id(0,Vector2(baseX+x,baseY+y)) == 0:
				return false
	return true
	
func setStructure(struct: PhysicalStructure, baseX:int, baseY:int):
	for x in range(struct.width):
		for y in range(struct.height):
			var final = Vector2(x,y)
			set_cell(0,Vector2i(baseX+x,baseY+y),struct.id,final)
		
