// 该代码块中包含了一些基本的与多边形相关的方法
// 比如对点、线的有关操作等
// 还有 点和多边形关系 的判断

// 线的lerp
function lineLerp(_line, _alpha) {
	return [lerp(_line[0][0], _line[1][0], _alpha), lerp(_line[0][1], _line[1][1], _alpha)];
}
// 点的平移
// 将 _point 的 x 和 y 分别加上 _x 和 _y
function shiftPoint(_point, _x, _y) {
	return [_point[0] + _x, _point[1] + _y];	
}
// 点的旋转
// 将 _point 绕原点顺时针旋转 _rot（角度）
function rotatePoint(_point, _rot) {
	var vcos = dcos(_rot), vsin = dsin(_rot);
	return [_point[0] * vcos - _point[1] * vsin, _point[0] * vsin + _point[1] * vcos];
}
// 将点坐标保留两位小数
function roundPoint(_point) {
	return [round(_point[0] * 100) / 100, round(_point[1] * 100) / 100];	
}

// 传入多边形顶点，转为 多边形的边
function vertsToLines(_verts, _x, _y, _rot) {
	var len = array_length(_verts);
	if len == 0
		return [];
	var res = [];
	array_resize(res, len);
	var prev = roundPoint(shiftPoint(rotatePoint(_verts[len - 1], _rot), _x, _y));
	for(var i = 0, j = len - 1; i < len; j = i++) {
		var cur = roundPoint(shiftPoint(rotatePoint(_verts[i], _rot), _x, _y));
		res[i] = [prev, cur];
		prev = cur;
	}
	return res;
}

enum RelState { Inside = 0, Outside = 1, OnLeft = 2, OnRight = 3 };

// 得到 (_x, _y) 在多边形边 _lines 的哪里，返回 RelState
function getPointRelToPolylines(_x, _y, _lines, _fn = undefined) {
	var len = array_length(_lines);
	var flag = false, onLinesFlag = false;
	for(var i = 0; i < len; i++) {
		var line = _fn == undefined ? _lines[i] : _fn(i, _lines);
		if _y <= min(line[0][1], line[1][1]) || _y > max(line[0][1], line[1][1])
			continue;
		var xx = line[0][0] + (_y - line[0][1]) * (line[1][0] - line[0][0]) / (line[1][1] - line[0][1]);
		if xx == _x
			onLinesFlag = true;
		if xx < _x
			flag = !flag;
	}
	if onLinesFlag {
		return flag ? RelState.OnRight : RelState.OnLeft;
	}
	return flag ? RelState.Inside : RelState.Outside;
}
// getPointRelToPolylines 的封装
function isPointInsidePolylines(_x, _y, _lines, _fn = undefined) {
	return getPointRelToPolylines(_x, _y, _lines, _fn) == RelState.Inside;
}

// 寻找 (_x, _y) 到 _lines 最近处
function limitPoint(_x, _y, _lines) {
	var len = array_length(_lines);
	if len == 0
		return [_x, _y];
	
	var nearestPos, nearestDis = -1;
	for(var i = 0; i < len; i++) {
		var line = _lines[i];
		if((line[0][0] - _x) * (line[0][0] - line[1][0]) + (line[0][1] - _y) * (line[0][1] - line[1][1]) < 0) {
			var dis = point_distance(_x, _y, line[0][0], line[0][1]);
			if(dis < nearestDis || nearestDis == -1) {
				nearestDis = dis;
				nearestPos = line[0];
			}
		} else if((line[1][0] - _x) * (line[1][0] - line[0][0]) + (line[1][1] - _y) * (line[1][1] - line[0][1]) < 0) {
			var dis = point_distance(_x, _y, line[1][0], line[1][1]);
			if(dis < nearestDis || nearestDis == -1) {
				nearestDis = dis;
				nearestPos = line[1];
			}
		} else {
			var k = ((_y - line[0][1]) * (line[1][0] - line[0][0]) - (_x - line[0][0]) * (line[1][1] - line[0][1]))
				/ (sqr(line[1][1] - line[0][1]) + sqr(line[1][0] - line[0][0]));
			var dis = abs(k) * point_distance(line[0][0], line[0][1], line[1][0], line[1][1]);
			if(dis < nearestDis || nearestDis == -1) {
				nearestDis = dis;
				nearestPos = [_x + k * (line[1][1] - line[0][1]), _y + k * (line[0][0] - line[1][0])];
			}
		}
	}
	return nearestPos;
}
