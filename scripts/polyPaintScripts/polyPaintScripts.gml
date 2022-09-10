// 该代码块中包含了一些与多边形遮罩绘制有关的代码

// 用于得到多边形的三角剖分
function polylinesTriangulation(_verts) {
	var len = array_length(_verts);
	if len < 3
		return [];
		
	// 针对数组的深拷贝
	function arrayDeepCopy(_arr) {
		var result = [];
		var len = array_length(_arr);
		array_resize(result, len);
		for(var i = 0; i < len; i++) {
			result[i] = is_array(_arr[i]) ? arrayDeepCopy(_arr[i]) : _arr[i];	
		}
		return result;
	}
	
	var verts = arrayDeepCopy(_verts);
	var result = [];
	
	// 辅助函数，用于当_index超出边界时循环
	// 因为都是稍微超出，所以只考虑了稍微超出时的情况
	function iloop(_index, _arr) {
		var len = array_length(_arr);
		if _index >= len
			return _index - len;
		if _index < 0
			return _index + len;
		return _index;
	}
	// 辅助函数，用于_index处的顶点是否可以剖分
	function canDivide(_index, _arr) {
		//判断是否为凸顶点，如果不是，则return false
		//实际上这里也有部分为凹顶点的情况无法被排除，但是后续的代码会同时排除掉这些
		var a1 = _arr[iloop(_index - 1, _arr)], a2 = _arr[iloop(_index + 1, _arr)];
		function lineAt(_index, _arr) { return [_arr[_index], _arr[iloop(_index + 1, _arr)]]; }
		if !isPointInsidePolylines((a1[0] + a2[0]) / 2, (a1[1] + a2[1]) / 2, _arr, lineAt)
			return false;
		
		//判断移除顶点后是否出现边相交
		var istart = _index + 2 - array_length(_arr), iend = _index - 2;
		function cp(_a1, _a2, _b1, _b2) { return (_a2[0] - _a1[0]) * (_b2[1] - _b1[1]) - (_a2[1] - _a1[1]) * (_b2[0] - _b1[0]); }
		for(var i = istart; i < iend; i++) {
			var b1 = _arr[iloop(i, _arr)], b2 = _arr[iloop(i + 1, _arr)];
			if sign(cp(a1, a2, a1, b1)) != sign(cp(a1, a2, a1, b2)) && sign(cp(b1, b2, b1, a1)) != sign(cp(b1, b2, b1, a2))
				return false;
		}
		return true;
	}
	
	// 进行剖分
	while(array_length(verts) >= 4) {
		var divided = false;
		for(var i = 0; i < array_length(verts); i++) {
			if canDivide(i, verts) {
				divided = true;
				array_push(result, [verts[iloop(i - 1, verts)], verts[i], verts[iloop(i + 1, verts)]]);
				array_delete(verts, i, 1);
				break;
			}
		}
		if !divided		//当出现死循环时（大多是因为多边形的边出现相交）直接结束
			return [];
	}
	array_push(result, [verts[0], verts[1], verts[2]]);
	
	return result;
}
