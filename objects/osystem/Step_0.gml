rot += 1;

x2 = 600 + 500 * dsin(rot);
y2 = 220;
polyLines2 = vertsToLines(polyVerts2, x2, y2, rot);
sub = polylineSub(polyLines1, polyLines2);

playerX += (keyboard_check(ord("D")) - keyboard_check(ord("A"))) * 10;
playerY += (keyboard_check(ord("S")) - keyboard_check(ord("W"))) * 10;

if !isPointInsidePolylines(playerX, playerY, sub) {
	var pos = limitPoint(playerX, playerY, sub);
	playerX = pos[0];
	playerY = pos[1];
}
