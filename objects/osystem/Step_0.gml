
poly2.x = 600 + 500 * dsin(poly2.rot);
poly2.y = 220;
mixed = mixPoly([poly1, poly2]);

playerX += (keyboard_check(ord("D")) - keyboard_check(ord("A"))) * 10;
playerY += (keyboard_check(ord("S")) - keyboard_check(ord("W"))) * 10;

if !isPointInsidePolylines(playerX, playerY, mixed) {
	var pos = limitPoint(playerX, playerY, mixed);
	playerX = pos[0];
	playerY = pos[1];
}
