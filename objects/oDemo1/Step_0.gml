// 将顶点转为边
lines = vertsToLines(poly.verts, poly.x, poly.y, poly.rot);

// 玩家移动
playerX += (keyboard_check(ord("D")) - keyboard_check(ord("A"))) * 8;
playerY += (keyboard_check(ord("S")) - keyboard_check(ord("W"))) * 8;

// 使用 isPointInsidePolylines 判断玩家是否在多边形内部
// 如果超出，则通过 limitPoint 将玩家限制回多边形内部
if !isPointInsidePolylines(playerX, playerY, lines) {
	var pos = limitPoint(playerX, playerY, lines);
	playerX = pos[0];
	playerY = pos[1];
}
