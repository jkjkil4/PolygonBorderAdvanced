/*if !surface_exists(surf)
	surf = surface_create(viewW(), viewH());
	
surface_set_target(surf);
draw_clear_alpha(c_black, 0);
draw_set_alpha(0.4 - 0.1 * dsin(poly2.rot * 4));
draw_set_color(c_yellow);
var offset = 150 + 50 * dsin(poly2.rot * 4);
draw_circle(playerX, playerY, offset, false);
draw_set_color(c_white);
draw_set_alpha(1);

clearAlpha(0);
mixAlpha([poly1, poly2]);
surface_reset_target();

draw_surface(surf, 0, 0);

draw_set_color(c_dkgray);
drawPoly(poly1, 3);
drawPoly(poly2, 3);

draw_set_color(c_fuchsia);
drawPolyByLines(mixed, 0, 0, 4);
*/
/*draw_set_color(c_aqua);
var add = polylineAdd(polyLines1, polyLines2);
for(var i = 0; i < array_length(add); i++) {
	var line = add[i];
	draw_line_width(line[0][0], line[0][1], line[1][0], line[1][1], 4);
}*/


/*draw_set_color(c_fuchsia);
for(var i = 0; i < array_length(sub); i++) {
	var line = sub[i];
	draw_line_width(line[0][0], line[0][1], line[1][0], line[1][1], 4);
}*/

/*
draw_set_color(c_white);
draw_circle(playerX, playerY, 8, false);
*/

