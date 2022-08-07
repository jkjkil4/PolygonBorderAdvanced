/*
	verts 存放顶点
	verts 中的每个元素是一个长度为2的数组，下标0和1分别表示顶点相对于实例的x和y
	例如下面这样，声明了4个顶点，表示了一个正方形
	verts = [
		[-40, -40], [40, -40],
		[-40, 40], [40, 40]
	]
	但是最好不要在这里修改，请在 Instance Creation Code 或者从其他实例控制这些内容
*/
verts = [];

/*
	旋转相关
	rot 表示顺时针旋转的角度
	rotSpeed 表示每步对rot的增量
*/
rot = 0;
rotSpeed = 0;

/*
	operFlag表明该多边形框是“加框”还是“减框”
	OF_Add 表示“加框”
	OF_Sub 表示“减框”
*/
enum OperateFlag { OF_Add, OF_Sub };
operFlag = OF_Add;
