/*
	该多边形限制框可以做到对超出限制框的点进行约束
	最好不要弄边相交的多边形，如果弄的话，可能导致无法成功进行三角剖分
	优点: 
		纯算法实现
		多边形实用性强
	缺点: 
		当在拐角移动时，可能穿过拐角（不会出框，原本是要绕过去）
		只能限制点（对于较小的物体实际上也可以当成一个点）
		编辑不便
	说明文档（都可以）:
		https://gitee.com/jkjkil4/PolygonBorderAdvanced/blob/master/README.md
		https://github.com/jkjkil4/PolygonBorderAdvanced/blob/master/README.md
	如果你需要移植到别的项目中，以下是你需要迁移的:
		oPolyBorderAdv、polyBasicScripts、polyBooleanScripts、polyPaintScripts
*/


/*	verts 存放顶点
	verts 中的每个元素是一个长度为2的数组，下标0和1分别表示顶点相对于实例的x和y
	例如下面这样，声明了4个顶点，表示了一个正方形
	verts = [
		[-40, -40], [40, -40],
		[-40, 40], [40, 40]
	]
	但是最好不要在这里修改，请在 Instance Creation Code 或者从其他实例控制这些内容
	
	如果你需要多边形遮罩，请在修改了verts的内容后，
	调用 updateTriangles() 更新 triangles */
verts = [];

/*	triangles 存放多边形的三角剖分
	三角剖分就是将多边形用多个三角形进行表示
	如果你要需要遮罩，请在 verts 发生改变后调用 updateTriangles 来更新 */
triangles = [];
function updateTriangles() { triangles = vertsTriangulation(verts); }

/*	旋转相关
	rot 表示顺时针旋转的角度
	rotSpeed 表示每步对rot的增量 */
rot = 0;
rotSpeed = 0;

/*	operFlag表明该多边形框是“加框”还是“减框”
	OF_Add 表示“加框”
	OF_Sub 表示“减框” */
enum OperateFlag { OF_Add, OF_Sub };
operFlag = OperateFlag.OF_Add;
