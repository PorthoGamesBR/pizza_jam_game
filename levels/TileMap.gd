extends TileMap
@export var mapHeight : int = 64
@export var mapWidth : int = 64
var chance : Array[Array] = [[325,25,25,3,3],[1, 25, 25, 3,12]]
var structure: Array[PhysicalStructure] = []
var rng = RandomNumberGenerator.new()
var matrix: Array[Array] = []

func populateStructure():
	var smallTree = PhysicalStructure.new(1, "SmallTree", 5, 3, 15)
	var bigTree = PhysicalStructure.new(2, "BigTree", 5, 3, 6)
	structure.append(smallTree)
	structure.append(bigTree)

func create_onibus():
	set_cell(1,Vector2i(0,0),3,Vector2(0,1))
	for x in range(13):
		for y in range(7):
			matrix[x-6][y-3] = true

func create_border():
	for x in range(12):
		for y in range(mapHeight+12):
			set_cell(0,Vector2i(-x-mapWidth/2-2,y-mapHeight/2-6),0,Vector2(0,0))
			set_cell(0,Vector2i(+x+mapWidth/2+1,mapHeight/2-y+6),0,Vector2(0,0))
	for y in range(6):
		for x in range(mapWidth+12):
			set_cell(0,Vector2i(x-mapWidth/2-6, -y-mapHeight/2-2),0,Vector2(0,0))
			set_cell(0,Vector2i(mapWidth/2-x+6,y+mapHeight/2+1),0,Vector2(0,0))
	for y in range(mapHeight+1):
		set_cell(0,Vector2i(-mapWidth/2-1,y-mapHeight/2-1),1,Vector2(1,3))
		set_cell(0,Vector2i(mapWidth/2,mapHeight/2-y),1,Vector2(1,3))
	for x in range(mapWidth+2):
		set_cell(0,Vector2i(x-mapHeight/2-1,-mapHeight/2-1),1,Vector2(1,3))
		set_cell(0,Vector2i(mapWidth/2-x,mapHeight/2),1,Vector2(1,3))

func _ready():
	create_border()
	for x in range(mapHeight):
		matrix.append([])
		for y in range(mapWidth):
			matrix[x].append(false)

	var total = 0
	for x in chance:
		for y in x:
			total+=y
	create_onibus()
	for x in range(mapHeight):
		for y in range(mapWidth):
			var random = rng.randf_range(0, total)
			var final = getAtlasId(random)
			if !getCell(x-mapWidth/2,y-mapHeight/2):
				set_cell(0,Vector2i(x-mapWidth/2,y-mapHeight/2),0,final)
			else:
				set_cell(0,Vector2i(x-mapWidth/2,y-mapHeight/2),4,Vector2(0,0))
			
	
	populateStructure()
	for struct in structure:
		generateStructure(struct)
		

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
		while !created :
			var baseX = rng.randf_range(0, mapWidth-struct.width)-mapWidth/2
			var baseY = rng.randf_range(0, mapHeight-struct.height)-mapHeight/2
			if verifyStructureConstruct(struct, baseX,baseY):
				created = true
				setStructure(struct, baseX, baseY)
			
func verifyStructureConstruct(struct: PhysicalStructure, baseX:int, baseY:int):
	for x in range(struct.width):
		for y in range(struct.height):
			if getCell(baseX+x,baseY+y):
				return false
	return true
	
func setStructure(struct: PhysicalStructure, baseX:int, baseY:int):
	for x in range(struct.width):
		for y in range(struct.height):
			setCell(baseX+x,baseY+y)
			var final = Vector2(x,y)
			set_cell(0,Vector2i(baseX+x,baseY+y),struct.id,final)
		
func getCell(x:int,y:int):
	return matrix[x][y]
		
func setCell(x:int,y:int):
	matrix[x][y] = true
