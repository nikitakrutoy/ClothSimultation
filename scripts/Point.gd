extends MeshInstance

var ks = 10.0
var kd = 0.7
var L0: float
var i: int
var j: int
var mass = 0.01
var prev_pos: Vector3
var speed = Vector3.ZERO;

var is_fixed = false

var g = 9.8

func _ready():
	mesh = SphereMesh.new()
	scale = 0.5 * Vector3.ONE
	
func get_speed(delta):
#	return (translation - prev_pos) / delta
	return speed
	
func cals_spring_force(p, delta):
	var d = translation.distance_to(p.translation)
	var dir: Vector3 = translation.direction_to(p.translation)
	var vA = get_speed(delta)
	var vB = p.get_speed(delta)
	var FS = (d - L0) * ks 
	var FD = dir.dot((vB - vA)) * kd
#	var FD = 0;
	var result = (FS + FD) * dir
	return  result

var accum = 0.0
var dt = 0.005

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	accum += delta
	if is_fixed:
		return 
	while accum >= dt:
		delta = dt
		var mat = get_parent().matrix
		var M = len(mat)
		var N = len(mat[0])
		var F = Vector3.ZERO
		if i == 1 and j == 0:
			var b = 1
		if j + 1 < N:
			var p = mat[i][j + 1]
			F += cals_spring_force(p, delta)
		if i + 1 < M:
			var p = mat[i + 1][j]
			F += cals_spring_force(p, delta)
		if j - 1 >= 0:
			var p = mat[i][j - 1]
			F += cals_spring_force(p, delta)
		if i - 1 >= 0:
			var p = mat[i - 1][j]
			F += cals_spring_force(p, delta)
			
		var a = F / mass - g * Vector3.UP
		speed += a * delta;
		var temp = translation
	#	translation = translation + speed * delta
	#	translation = Vector3.UP * delta
		translation = 2 * translation - prev_pos + a * delta * delta
		prev_pos = temp
		accum -= dt

