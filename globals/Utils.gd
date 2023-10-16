extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func sortByNumber(a: Dictionary, b: Dictionary):
	if a.number < b.number:
		return true
	if a.number == b.number:
		if abs(a.aspectRatio - 1) < abs(b.aspectRatio - 1):
			return true
		return false
	return false


func sortByAspectRatioClosestToOne(a: Dictionary, b: Dictionary):
	if abs(a.aspectRatio - 1) < abs(b.aspectRatio - 1):
		return true
	if abs(a.aspectRatio - 1) == abs(b.aspectRatio - 1):
		if a.number < b.number:
			return true
		return false
	return false


func findFactors(number: int) -> Array[int]:
	var factors: Array[int] = [];

	# need to start from i = 1 so we dont end up dividing 0 by 0
	for i in range(1, number + 1):
		#print('fFactors i:', i)
		if number % i == 0:
			factors.append(i);
	return factors;


func findNumbersWithAspectRatios(_rangeStart: float, _rangeEnd: float, _minRatio: float, _maxRatio: float) -> Array[Dictionary]:
	var validNumbers: Array[Dictionary] = [];
	
	for number in range(_rangeStart, _rangeEnd):
		#print('|- NUMBER:', number)
		if number % 2 == 0:
			#print('|-- is % 2 == 0:')
			var factors = findFactors(number);
			#print('|-- factors', factors);
			
			for i in int(ceil(factors.size()/2.0)):
				#print('|-- size:', factors.size(), " factors.size/2: ", int(factors.size()/2.0))
				var rows: float = factors[i];
				var columns: float = factors[factors.size() - 1 - i];
				#print('|-- ', 'r: ', rows, ' c: ', columns)
				var variantRC: float = float(rows / columns);
				var variantCR: float = float(columns / rows);
				
				# variant one of two e.g. 4:3 
				if _minRatio <= variantRC and variantRC <= _maxRatio and not variantRC == variantCR:
					var entry = {}
					entry.number = number;
					entry.width = rows;
					entry.height = columns;
					entry.aspectRatio = float(rows / columns);
					validNumbers.append(entry);
					
				# case of reverse ratio e.g. 3:4
				if _minRatio <= variantCR and variantCR <= _maxRatio:
					var entry = {}
					entry.number = number;
					entry.width = columns;
					entry.height = rows;
					entry.aspectRatio = float(columns / rows);
					validNumbers.append(entry);
		#print('|')
	return validNumbers;


func get_all_files(path: String, files: Array, filter: Array[String] = []):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if dir.current_is_dir():
				#print("Found directory: " + file_name)
				get_all_files("%s/%s" % [path, file_name], files, filter)
			else:
				if filter.is_empty():
					files.push_back("%s/%s" % [path, file_name])
					#print("Found file: " + file_name)
				else:
					if file_name.get_extension() in filter and file_name.contains('Faceset'):
						#print('FILE: ', file_name, ' contains: ', file_name.contains('Faceset'))
						files.push_back("%s/%s" % [path, file_name])
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
