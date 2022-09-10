// 一个遮罩的例子
// 包含: 玩家移动限制，多边形旋转，加减框，绘制遮罩

// 在(700,400)处创建一个类圆形
poly = instance_create_depth(700, 400, 0, oPolyBorderAdv);
array_resize(poly.verts, 32);
for(var i = 0; i < 32; i++) {	// 设定多边形的顶点
	poly.verts[i] = [380 * cos(i * pi / 16), 380 * sin(i * pi / 16)];
}
poly.updateTriangles(); // 更新 triangles，因为要用遮罩

// 旋转的多边形
polyRoting = instance_create_depth(700, 400, 0, oPolyBorderAdv);
polyRoting.verts = [
	[60, 60], [60, 30], [400, 30], [400, -30], [60, -30],
	[60, -60], [-60, -60], [-60, -30], [-400, -30],
	[-400, 30], [-60, 30], [-60, 60]
];
polyRoting.rotSpeed = 0.5;
polyRoting.operFlag = OperateFlag.OF_Sub;
polyRoting.updateTriangles();

// 左侧多边形
poly1 = instance_create_depth(500, 400, 0, oPolyBorderAdv);
poly1.verts = [[50, 60], [-50, 60], [-50, -60], [50, -60]];
poly1.updateTriangles();

// 右侧多边形
poly2 = instance_create_depth(900, 400, 0, oPolyBorderAdv);
poly2.verts = [[50, 60], [-50, 60], [-50, -60], [50, -60]];
poly2.updateTriangles();

// 参与运算的多边形
polys = [poly, polyRoting, poly1, poly2];
// 记录运算后的结果
mixed = [];

// 用于遮罩的 surface
surf = surface_create(viewW(), viewH());
function repaintSurf() {
	surface_set_target(surf);
	draw_clear(c_fuchsia);
	surface_reset_target();
}
repaintSurf();

// 玩家的坐标
playerX = 0;
playerY = 0;
