if !surface_exists(surf)
	surf = surface_create(viewW(), viewH());

// 设置绘制到surf上
surface_set_target(surf);	

// 绘制：填充紫色，玩家周围画黄色圈
draw_clear(c_fuchsia);
draw_set_color(c_yellow);
draw_circle(playerX, playerY, 100, false);

// 将surf上的透明度全部设置为0（完全透明），然后再用 mixAlpha 根据多边形来对透明度进行修改
clearAlpha(0);	
mixAlpha(polys, 0, 0, 0, 0.2, 0);

// 设置绘制到屏幕上
surface_reset_target();	
// 绘制surf
draw_surface(surf, 0, 0);	

// 绘制运算后的多边形
draw_set_color(c_fuchsia);
drawPolyByLines(mixed, 0, 0, 4);

// 绘制玩家（一个白点）
draw_set_color(c_white);
draw_circle(playerX, playerY, 8, false);
