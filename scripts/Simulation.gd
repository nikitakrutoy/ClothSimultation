extends Spatial


const Point = preload("res://scripts/Point.gd") 
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var width: int = 10
export var height: int = 10
export var dist: int = 1
var matrix=[]


# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(width):
		matrix.append([])
		for y in range(height):
			matrix[x].append(0)
	var m = 0
	for i in range(-width * dist, width * dist - 1, 2 * dist):
		var n = 0
		for j in range(-height * dist , height * dist - 1, 2 * dist):
			var mesh = Point.new();
			matrix[m][n] = mesh
			mesh.translation = Vector3(i / 2, 0, j / 2);
			mesh.prev_pos = mesh.translation
			mesh.i = m
			mesh.j = n
			mesh.L0 = dist
			add_child(mesh);
			n += 1
		m += 1
	
	matrix[0][0].is_fixed = true
	matrix[0][height -1 ].is_fixed = true
	matrix[width - 1][0].is_fixed = true
	matrix[width - 1][height - 1].is_fixed = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
