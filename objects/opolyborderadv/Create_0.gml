/*
	arrVertex顶点存放方式：
	arrVertex中的每个元素是一个长度为2的数组，下标0和1分别表示顶点相对于实例的x和y
	例如下面这样，声明了4个顶点，表示了一个正方形
	verts = [
		[10, 10], [40, 10],
		[40, 40], [10, 40]
	]
*/
verts = [];

/*
	operFlag表明该多边形框是“加框”还是“减框”
	OF_Add 表示“加框”
	OF_Sub 表示“减框”
*/
enum OperateFlag { OF_Add, OF_Sub };
operFlag = OF_Add;
