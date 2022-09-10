if !surface_exists(surf) {
	surf = surface_create(viewW(), viewH());
	repaintSurf();
}

// 将遮罩应用于表面
surface_set_target(surf);
clearAlpha(0);
mixAlpha(polys, 0, 0, 0, 0.2, 0);
surface_reset_target();
draw_surface(surf, 0, 0);

// 绘制运算后的多边形
draw_set_color(c_fuchsia);
drawPolyByLines(mixed, 0, 0, 4);

// 绘制玩家（一个白点）
draw_set_color(c_white);
draw_circle(playerX, playerY, 8, false);
