
//var polyLines2 = vertsToLines(polyVerts2, polyX2, polyY2, rot);

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
var sub = polylineSub(polyLines1, polyLines2);
for(var i = 0; i < array_length(sub); i++) {
	var line = sub[i];
	draw_line_width(line[0][0], line[0][1], line[1][0], line[1][1], 4);
}

draw_set_color((getPointRelToPolylines(mouse_x, mouse_y, sub) == RelState.Inside) ? c_green : c_red);
draw_circle(mouse_x, mouse_y, 8, false);

draw_set_color(c_white);
