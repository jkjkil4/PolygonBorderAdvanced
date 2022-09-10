// 用灰色绘制用于加减框的多边形
draw_set_color(c_dkgray);
drawPoly(poly1, 3);
drawPoly(poly2, 3);

// 绘制运算后的多边形
draw_set_color(c_fuchsia);
drawPolyByLines(mixed, 0, 0, 4);

// 绘制玩家（一个白点）
draw_set_color(c_white);
draw_circle(playerX, playerY, 8, false);
