// 该代码块中包含了一些基本的与多边形相关的方法
// 比如对点、线的有关操作等
// 还有 点和多边形关系 的判断

// 线的lerp
// 传入参数:
//     _line: 线段
//     _alpha: 占线段的比例（比如：若为0，则返回_line[0]；若为1，则返回_line[1]；否则通过插值返回_line上的一个点）
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
// 传入参数:
//     _verts: 多边形的顶点
//     _x: 多边形的x
//     _y: 多边形的y
//     _rot: 绕(_x,_y)顺时针旋转角度
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

// 枚举点与多边形边的相对关系，用于 getPointRelToPolylines
// Inside: 位于多边形内部
// Outside: 位于多边形外部
// OnLeft: 刚好落在多边形左侧的边上
// OnRight: 刚好落在多边形右侧的边上
// 区分左右，是为了进行一些边界条件的判断
enum RelState { Inside = 0, Outside = 1, OnLeft = 2, OnRight = 3 };

// 得到 (_x, _y) 在多边形边 _lines 的哪里，返回 RelState
// 传入参数:
//     _x: 要判断的点的x
//     _y: 要判断的点的y
//     _lines: 多边形边
//     _fn: 请忽略，仅用于 vertsTriangulation 中便捷地将点映射到边
function getPointRelToPolylines(_x, _y, _lines, _fn = undefined) {
	var len = array_length(_lines);
	var flag = false, onLinesFlag = false;
	for(var i = 0; i < len; i++) {
		var line = is_undefined(_fn) ? _lines[i] : _fn(i, _lines);
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
// 传入参数:
//     _x: 要限制的点的x
//     _y: 要限制的点的y
//     _lines: 多边形边
function limitPoint(_x, _y, _lines) {
	var len = array_length(_lines);
	if len == 0
		return [_x, _y];
	
	var nearestPos, nearestDis = -1;
	for(var i = 0; i < len; i++) {
		var line = _lines[i];
		// 若该线段没有长度，则跳过
		if line[0][0] == line[1][0] && line[0][1] == line[1][1]
			continue;
		// 根据情况计算 dis，进行比较
		if (line[0][0] - _x) * (line[0][0] - line[1][0]) + (line[0][1] - _y) * (line[0][1] - line[1][1]) < 0 {
			var dis = point_distance(_x, _y, line[0][0], line[0][1]);
			if(dis < nearestDis || nearestDis == -1) {
				nearestDis = dis;
				nearestPos = line[0];
			}
		} else if (line[1][0] - _x) * (line[1][0] - line[0][0]) + (line[1][1] - _y) * (line[1][1] - line[0][1]) < 0 {
			var dis = point_distance(_x, _y, line[1][0], line[1][1]);
			if(dis < nearestDis || nearestDis == -1) {
				nearestDis = dis;
				nearestPos = line[1];
			}
		} else {
			var k = ((_y - line[0][1]) * (line[1][0] - line[0][0]) - (_x - line[0][0]) * (line[1][1] - line[0][1]))
				/ (sqr(line[1][1] - line[0][1]) + sqr(line[1][0] - line[0][0]));
			var dis = abs(k) * point_distance(line[0][0], line[0][1], line[1][0], line[1][1]);
			if dis < nearestDis || nearestDis == -1 {
				nearestDis = dis;
				nearestPos = [_x + k * (line[1][1] - line[0][1]), _y + k * (line[0][0] - line[1][0])];
			}
		}
	}
	return nearestPos;
}
