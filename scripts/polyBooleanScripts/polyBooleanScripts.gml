// 该代码块中包含了一些与多边形布尔运算有关的方法
// 包含线相交的判断、多边形的切割和加减

// 预判断线相交
// 该方法仅判断了两条线的外围矩形，还需 lineCollision 才能准确判断
function lineCollisionPre(_line1, _line2) {
	return max(_line2[0][0], _line2[1][0]) >= min(_line1[0][0], _line1[1][0])
		&& min(_line2[0][0], _line2[1][0]) <= max(_line1[0][0], _line1[1][0])
		&& max(_line2[0][1], _line2[1][1]) >= min(_line1[0][1], _line1[1][1])
		&& min(_line2[0][1], _line2[1][1]) <= max(_line1[0][1], _line1[1][1]);
}
// 准确判断线段相交情况，返回交点占 _line1 的比例，若没有则返回 noone
function lineCollision(_line1, _line2) {
	var v1 = (_line2[0][0] - _line1[0][0]) * (_line1[1][1] - _line1[0][1]) - (_line1[1][0] - _line1[0][0]) * (_line2[0][1] - _line1[0][1]);
	var v2 = (_line2[1][0] - _line1[0][0]) * (_line1[1][1] - _line1[0][1]) - (_line1[1][0] - _line1[0][0]) * (_line2[1][1] - _line1[0][1]);
	if sign(v1) == sign(v2)
		return noone;
	
	var down = (_line1[1][0] - _line1[0][0]) * (_line2[1][1] - _line2[0][1]) - (_line1[1][1] - _line1[0][1]) * (_line2[1][0] - _line2[0][0]);
	if down == 0
		return noone;
	var up = (_line2[0][0] - _line1[0][0]) * (_line2[1][1] - _line2[0][1]) - (_line2[0][1] - _line1[0][1]) * (_line2[1][0] - _line2[0][0]);
	var alpha = up / down;
	return (alpha > 0 && alpha < 1) ? alpha : noone;
}

// _lines1 和 _lines2 互相切割
function polylinesInterclip(_lines1, _lines2) {
	// clips1 表示 _lines1 被 _lines2 分割后的结果
	// clips2 表示 _lines2 被 _lines1 分割后的结果
	var clips1 = [], clips2 = [];
	// 分别为 _lines1 和 _line2 的边的数量
	var len1 = array_length(_lines1), len2 = array_length(_lines2);
	
	// 遍历 _lines1 中所有的边
	for(var i = 0; i < len1; i++) {
		var line1 = _lines1[i];
		// 存放 line1 被分割后产生的交点，用交点位置占线段的比例表示
		var alphas = [];
		// 遍历 _lines2，对 line1 进行分割
		for(var j = 0; j < len2; j++) {
			var line2 = _lines2[j];
			
			// 用矩形区域预判断线段是否相交，节省性能开销
			if !lineCollisionPre(line1, line2)
				continue;
			// 进一步得到线段交点情况，noone表示没有交点，否则表示占线段比例
			var alpha = lineCollision(line1, line2);
			if alpha == noone
				continue;
				
			array_push(alphas, alpha);
		}
		// 将 alphas 的交点处理后加入 clips1
		array_sort(alphas, true);
		var prevEnd = line1[0];
		var aphCnt = array_length(alphas);
		for(var k = 0; k < aphCnt; k++) {
			var curEnd = lineLerp(line1, alphas[k]);
			array_push(clips1, [prevEnd, curEnd]);
			prevEnd = curEnd;
		}
		array_push(clips1, [prevEnd, line1[1]]);
	}
	
	// 遍历 _lines2 中所有的边
	// 和前面一个类似，所以就不写太多注释了
	for(var i = 0; i < len2; i++) {
		var line2 = _lines2[i];
		var alphas = [];
		for(var j = 0; j < len1; j++) {
			var line1 = _lines1[j];
			if !lineCollisionPre(line2, line1)
				continue;
			
			var alpha = lineCollision(line2, line1);
			if (alpha == noone)
				continue;
			
			array_push(alphas, alpha);
		}
		
		array_sort(alphas, true);
		var prevEnd = line2[0];
		var aphCnt = array_length(alphas);
		for(var k = 0; k < aphCnt; k++) {
			var curEnd = lineLerp(line2, alphas[k]);
			array_push(clips2, [prevEnd, curEnd]);
			prevEnd = curEnd;
		}
		array_push(clips2, [prevEnd, line2[1]]);
	}
	
	return [clips1, clips2];
}

// 加框，_lines1 + _lines2
function polylineAdd(_lines1, _lines2) {
	var clips = polylinesInterclip(_lines1, _lines2);
	var clips1 = clips[0], len1 = array_length(clips1);
	var clips2 = clips[1], len2 = array_length(clips2);
	var result = [];
	for(var i = 0; i < len1; i++) {
		var line = clips1[i];
		var center = lineLerp(line, 0.5);
		var rel = getPointRelToPolylines(center[0], center[1], _lines2);
		if rel > 1 {	// 正好落在边上
			var relSelf = getPointRelToPolylines(center[0], center[1], _lines1);
			if relSelf == rel
				array_push(result, line);
		} else {	// 没有落在边上
			if rel == RelState.Outside
				array_push(result, line);
		}
	}
	for(var i = 0; i < len2; i++) {
		var line = clips2[i];
		var center = lineLerp(line, 0.5);
		var rel = getPointRelToPolylines(center[0], center[1], _lines1);
		if rel == RelState.Outside
			array_push(result, line);
	}
	return result;
}

// 减框 _lines1 - _lines2
function polylineSub(_lines1, _lines2) {
	var clips = polylinesInterclip(_lines1, _lines2);
	var clips1 = clips[0], len1 = array_length(clips1);
	var clips2 = clips[1], len2 = array_length(clips2);
	var result = [];
	for(var i = 0; i < len1; i++) {
		var line = clips1[i];
		var center = lineLerp(line, 0.5);
		var rel = getPointRelToPolylines(center[0], center[1], _lines2);
		if rel > 1 {	// 正好落在边上
			var relSelf = getPointRelToPolylines(center[0], center[1], _lines1);
			if relSelf != rel
				array_push(result, line);
		} else {	//没有落在边上
			if rel == RelState.Outside
				array_push(result, line);
		}
	}
	for(var i = 0; i < len2; i++) {
		var line = clips2[i];
		var center = lineLerp(line, 0.5);
		var rel = getPointRelToPolylines(center[0], center[1], _lines1);
		if rel == RelState.Inside
			array_push(result, line);
	}
	return result;
}

// 遍历 _polys，应用 polylineAdd 和 polylineSub，返回运算后的多边形边
function mixPoly(_polys) {
	var len = array_length(_polys);
	var result = [];
	for(var i = 0; i < len; i++) {
		var poly = _polys[i];
		result = (poly.operFlag == OperateFlag.OF_Add ? polylineAdd : polylineSub)(result, vertsToLines(poly.verts, poly.x, poly.y, poly.rot));
	}
	return result;
}