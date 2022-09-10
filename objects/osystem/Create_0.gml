polyVerts1 = [
	[300, 200], [900, 50], [900, 600], [300, 600]
];
polyLines1 = vertsToLines(polyVerts1, 0, 0, 0);
polyTriangles1 = vertsTriangulation(polyVerts1);

polyVerts2 = [
	[-100, -100], [100, -100], [100, 100], [-100, 100]
];
polyLines2 = []
polyTriangles2 = vertsTriangulation(polyVerts2);
x2 = 0;
y2 = 0;

sub = []

rot = 0;

playerX = 0;
playerY = 0;

surf = surface_create(viewW(), viewH());
