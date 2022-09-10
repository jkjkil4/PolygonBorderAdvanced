// 设置 poly1 和 poly2 的横坐标
poly1.x = 700 - 450 * dsin(poly1.rot);
poly2.x = 700 + 450 * dsin(poly2.rot);

// 进行加减框的运算
mixed = mixPoly([poly, poly1, poly2]);

// 玩家移动
playerX += (keyboard_check(ord("D")) - keyboard_check(ord("A"))) * 8;
playerY += (keyboard_check(ord("S")) - keyboard_check(ord("W"))) * 8;

// 限制
if !isPointInsidePolylines(playerX, playerY, mixed) {
	var pos = limitPoint(playerX, playerY, mixed);
	playerX = pos[0];
	playerY = pos[1];
}
