extends TileMap
@export var map_height : int = 64
@export var map_width : int = 64
var chance : Array[Array] = [[325,25,25,3,3],[1, 25, 25, 3,12]]
var structure: Array[PhysicalStructure] = []
var spawnables : = []
var rng = RandomNumberGenerator.new()
var matrix: Array[Array] = []

func populate_structure():
	structure = []
	var small_tree = PhysicalStructure.new(1, "SmallTree", 5, 3, 15)
	var big_tree = PhysicalStructure.new(2, "BigTree", 5, 3, 6)
	structure.append(small_tree)
	structure.append(big_tree)

func populate_spawnable():
	spawnables = []
	spawnables.append({"packedScene":preload("res://characters/wolf.tscn"),"qtd":20,"height":2,"width":3})

func spawnable_to_struct(spawnables) -> PhysicalStructure:
	return PhysicalStructure.new(3,"spawnable",spawnables["height"],spawnables["width"],spawnables["qtd"])

func create_onibus():
	set_cell(1,Vector2i(0,0),3,Vector2(0,1))
	for x in range(13):
		for y in range(7):
			matrix[x-6][y-3] = true
			

func create_border():
	for x in range(12):
		for y in range(map_height+12):
			set_cell(0,Vector2i(-x-map_width/2-2,y-map_height/2-6),0,Vector2(0,0))
			set_cell(0,Vector2i(+x+map_width/2+1,map_height/2-y+6),0,Vector2(0,0))
	for y in range(6):
		for x in range(map_width+12):
			set_cell(0,Vector2i(x-map_width/2-6, -y-map_height/2-2),0,Vector2(0,0))
			set_cell(0,Vector2i(map_width/2-x+6,y+map_height/2+1),0,Vector2(0,0))
	for y in range(map_height+1):
		set_cell(0,Vector2i(-map_width/2-1,y-map_height/2-1),1,Vector2(1,3))
		set_cell(0,Vector2i(map_width/2,map_height/2-y),1,Vector2(1,3))
	for x in range(map_width+2):
		set_cell(0,Vector2i(x-map_height/2-1,-map_height/2-1),1,Vector2(1,3))
		set_cell(0,Vector2i(map_width/2-x,map_height/2),1,Vector2(1,3))

func _ready():
	matrix = []
	create_border()
	for x in range(map_height):
		matrix.append([])
		for y in range(map_width):
			matrix[x].append(false)

	var total = 0
	for x in chance:
		for y in x:
			total+=y
	create_onibus()
	for x in range(map_height):
		for y in range(map_width):
			var random = rng.randf_range(0, total)
			var final = get_atlas_id(random)
			if !get_cell_matrix(x-map_width/2,y-map_height/2):
				set_cell(0,Vector2i(x-map_width/2,y-map_height/2),0,final)
			else:
				set_cell(0,Vector2i(x-map_width/2,y-map_height/2),4,Vector2(0,0))
			
	
	populate_structure()
	for struct in structure:
		generate_structure(struct)
	populate_spawnable()
	for spawnable in spawnables:
		generate_spawnable(spawnable)

func get_atlas_id(val):
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

func generate_spawnable(spawnables):
	for i in range(spawnables['qtd']):
		var created = false
		while !created:
			print(spawnables['qtd'])
			var base_x = rng.randf_range(0, map_width-spawnables["width"])-map_width/2
			var base_y = rng.randf_range(0, map_height-spawnables["height"])-map_height/2
			if verify_structure_construct(spawnable_to_struct(spawnables), base_x, base_y):
				created = true
				set_spawnable(spawnables, base_x, base_y)
				
func generate_structure(struct: PhysicalStructure):
	for i in range(struct.qtd):
		var created = false
		while !created :
			var base_x = rng.randf_range(0, map_width-struct.width)-map_width/2
			var base_y = rng.randf_range(0, map_height-struct.height)-map_height/2
			if verify_structure_construct(struct, base_x,base_y):
				created = true
				set_structure(struct, base_x, base_y)
				
			
func verify_structure_construct(struct: PhysicalStructure, base_x:int, base_y:int):
	for x in range(struct.width):
		for y in range(struct.height):
			if get_cell_matrix(base_x+x,base_y+y):
				return false
	return true
	
func set_spawnable(spawnables, base_x:int, base_y:int):
	var final
	var final_i
	for x in range(spawnables["width"]):
		for y in range(spawnables["height"]):
			set_cell_matrix(base_x+x,base_y+y)
			final = Vector2(base_x+x,base_y+y)
			final_i = Vector2i(base_x+x,base_y+y)
	var spw = spawnables["packedScene"].instantiate()
	get_parent().add_child.call_deferred(spw)
	spw.global_position = to_global(map_to_local(final_i))
			
func set_structure(struct: PhysicalStructure, base_x:int, base_y:int):
	for x in range(struct.width):
		for y in range(struct.height):
			set_cell_matrix(base_x+x,base_y+y)
			var final = Vector2(x,y)
			set_cell(0,Vector2i(base_x+x,base_y+y),struct.id,final)
		
func get_cell_matrix(x:int,y:int):
	return matrix[x][y]
		
func set_cell_matrix(x:int,y:int):
	matrix[x][y] = true
