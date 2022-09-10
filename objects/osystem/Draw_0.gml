if !surface_exists(surf)
	surf = surface_create(viewW(), viewH());
	
surface_set_target(surf);
draw_clear_alpha(c_black, 0);
draw_set_alpha(0.4 - 0.1 * dsin(rot * 4));
draw_set_color(c_yellow);
var offset = 150 + 50 * dsin(rot * 4);
draw_circle(playerX, playerY, offset, false);
draw_set_color(c_white);
draw_set_alpha(1);

clearAlpha(0);
replaceAlpha(polyTriangles1, 0, 0, 0, 1);
replaceAlpha(polyTriangles2, x2, y2, rot, 0);
surface_reset_target();

draw_surface(surf, 0, 0);

draw_set_color(c_dkgray);

for(var i = 0; i < array_length(polyLines1); i++) {
	var line = polyLines1[i];
	draw_line_width(line[0][0], line[0][1], line[1][0], line[1][1], 3);
}

for(var i = 0; i < array_length(polyLines2); i++) {
	var line = polyLines2[i];
	draw_line_width(line[0][0], line[0][1], line[1][0], line[1][1], 3);
}

/*draw_set_color(c_aqua);
var add = polylineAdd(polyLines1, polyLines2);
for(var i = 0; i < array_length(add); i++) {
	var line = add[i];
	draw_line_width(line[0][0], line[0][1], line[1][0], line[1][1], 4);
}*/


draw_set_color(c_fuchsia);
for(var i = 0; i < array_length(sub); i++) {
	var line = sub[i];
	draw_line_width(line[0][0], line[0][1], line[1][0], line[1][1], 4);
}


draw_set_color(c_white);
draw_circle(playerX, playerY, 8, false);


