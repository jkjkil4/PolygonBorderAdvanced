// 绘制边框
draw_set_color(c_fuchsia);
drawPoly(poly, 4);

// 绘制玩家（一个白点）
draw_set_color(c_white);
draw_circle(playerX, playerY, 8, false);
