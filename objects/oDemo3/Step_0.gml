// 进行加减框的运算
mixed = mixPoly(polys);

// 玩家移动
playerX += (keyboard_check(ord("D")) - keyboard_check(ord("A"))) * 8;
playerY += (keyboard_check(ord("S")) - keyboard_check(ord("W"))) * 8;

// 限制
if !isPointInsidePolylines(playerX, playerY, mixed) {
	var pos = limitPoint(playerX, playerY, mixed);
	playerX = pos[0];
	playerY = pos[1];
}
