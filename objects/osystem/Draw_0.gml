
// draw_set_color(c_dkgray);

/*for(var i = 0; i < array_length(polyLines1); i++) {
	var line = polyLines1[i];
	draw_line_width(line[0][0], line[0][1], line[1][0], line[1][1], 3);
}

for(var i = 0; i < array_length(polyLines2); i++) {
	var line = polyLines2[i];
	draw_line_width(line[0][0], line[0][1], line[1][0], line[1][1], 3);
}*/

/*draw_set_color(c_aqua);
var add = polylineAdd(polyLines1, polyLines2);
for(var i = 0; i < array_length(add); i++) {
	var line = add[i];
	draw_line_width(line[0][0], line[0][1], line[1][0], line[1][1], 4);
}*/

/*
draw_set_color(c_fuchsia);
for(var i = 0; i < array_length(sub); i++) {
	var line = sub[i];
	draw_line_width(line[0][0], line[0][1], line[1][0], line[1][1], 4);
}
*/

/*
draw_set_color(c_white);
draw_circle(playerX, playerY, 8, false);

draw_set_color(c_white);*/

colors = [c_red, c_blue, c_green, c_aqua, c_yellow, c_maroon];

draw_set_alpha(0.3);
for(var i = 0; i < array_length(tris); i++) {
	var tri = tris[i];
	draw_set_color(colors[i % array_length(colors)]);
	draw_primitive_begin(pr_trianglelist);
	draw_vertex(tri[0][0], tri[0][1]);
	draw_vertex(tri[1][0], tri[1][1]);
	draw_vertex(tri[2][0], tri[2][1]);
	draw_primitive_end();
}
draw_set_alpha(1);

draw_set_color(c_white);
for(var i = 0; i < array_length(lines); i++) {
	var line = lines[i];
	draw_line_width(line[0][0], line[0][1], line[1][0], line[1][1], 4);
}

