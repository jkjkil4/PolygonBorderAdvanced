# PolygonBorderAdvanced

更完善的多边形框  
基于布尔运算进行加减  

更简单的版本：[https://gitee.com/jkjkil4/PolygonBorder](https://gitee.com/jkjkil4/PolygonBorder)

### 介绍
在GMS2（2.3以上版本）中可用的多边形限制框

### 功能
以下列出了我实现的功能
- **判断点是否在框内**
- **得到点与多边形框最近的位置（用于在出框后限制回框内）**
- **对多边形内部区域进行遮罩（将显示范围限制在框内，[示例3](objects/oDemo3)中有涉及）**
- **多边形框旋转**
- **多边形框布尔运算（“加框”和“减框”，[示例2](objects/oDemo2)和[示例3](objects/oDemo3)中有涉及）**

### 使用
- 创建框
    - oPolyBorderAdv 是框的对象
    - 使用 **instance_create_depth** 或 **instance_create_layer** 创建一个框  
    为了方便描述，后文称该框为 **poly**
- 编辑顶点
    - **poly.verts** 为存储多边形的顶点的数组
    - 例如 `poly.verts = [[0, 0], [50, 50], [-50, 50]];`  
    即可向多边形添加 **(0, 0)**、**(50, 50)**、**(-50, 50)** 三个顶点
    - 其他操作如删除顶点等就不再赘述，对 **verts** 进行操作即可
    - *注：添加的顶点坐标都是相对与多边形原点而言的*
- 加框和减框
    - 每个 oPolyBorderAdv 的实例都使用 **operFlag** 来控制是加框还是减框  
    **OperateFlag.OF_Add** 表示“加框”，**OperateFlag.OF_Sub** 表示“减框”
    - 使用 `mixPoly([poly1, poly2, ...])` 来得到加减后的结果
    - 比如该情况下表示两框相加：
        ```javascript
        ...
        // 默认 OF_Add，不写也行
        poly1.operFlag = OperateFlag.OF_Add;    // “加框”
        poly2.operFlag = OperateFlag.OF_Add;    // “加框”
        mixed = mixPoly([poly1, poly2]);    // 两框相加的结果
        ```
    - 再比如该情况下表示两框相减：
        ```javascript
        ...
        poly1.operFlag = OF_Add;    // “加框”
        poly2.operFlag = OF_Sub;    // “减框”
        mixed = mixPoly([poly1, poly2]);    // 两框相减的结果
        ```
    - 如果传入更多的多边形，则按顺序进行运算：
        ```javascript
        ...
        /* poly1, poly2, poly3 的 operFlag 分别为 OF_Add, OF_Sub, OF_Add */
        mixed = mixPoly([poly1, poly2, poly3]); // poly1 先减去 poly2，再加上 poly3
        ```
    - 加减后的结果，是以数组方式存储的边，可以用于 isPointInsidePolylines、limitPoint等，将在后文提到
- 将点限制在框内
    - 为了将点限制在框内，首先要判断是否出框 
        - 使用 `isPointInsidePolylines(x, y, lines)` 即可判断 **(x, y)** 是否在框内
        - 其中 **lines** 表示一个数组，其中存放的是多边形的边，使用上文提到的 **mixPoly(\[...\])** 来得到  
    - 如果出框的话，就需要得到离边框最近的位置
        - 使用 `limitPoint(x, y, lines)` 即可得到 **(x, y)** 离 **lines** 最近的位置  
        返回值是一个长度为2的数组，下标 **0、1** 分别是结果的 **x、y** 
    - 所以最终的做法就是（如[示例1](objects/oDemo1)）：
        ```javascript
        // 步事件(Step Event)
        var lines = mixPoly([poly]);    // 得到边

        if !isPointInsidePolylines(playerX, playerY, lines) {   //判断是否在内部
            var pos = limitPoint(playerX, playerY, lines);  //如果不在内部则得到限制结果
            playerX = pos[0];
            playerY = pos[1];
        }
        ```
- 对多边形框内部进行遮罩
    - 当你需要用到遮罩时，需要在对顶点进行更改之后  
    调用 `poly.updateTriangles()` 来更新多边形的三角剖分
    - 为了使用遮罩，你需要创建一个表面（Surface），一般和屏幕大小一致  
    为了方便描述，后文称该表面为 **surf**
    - 与 `mixPoly([...])` 类似，调用 `mixAlpha([..])` 即可使用遮罩，（如[示例3](objects/oDemo3)）：
        ```javascript
        //绘制事件(Draw Event)
        if !surface_exists(surf)    //当surf凭空消失时重新创建
            surf = surface_create(/* 宽 */, /* 高 */);
        
        surface_set_target(surf);   //设置在surf上绘制
        
        /* 
            这里写想要被遮罩的东西 
            （一般最开始先draw_clear或draw_clear_alpha清空原有内容，然后再绘制东西）
        */

        clearAlpha(0);      // 将 surf 上的透明度全部设置为 0（完全透明）
        mixAlpha(polys);    // 根据多边形来对透明度进行修改

        surface_reset_target();     // 设置在屏幕上绘制
        draw_surface(surf, 0, 0);   // 绘制 surf
        ```
- 多边形框旋转
    - 调整 **poly.rot** 即可调整旋转角度（顺时针）
    - 调整 **poly.rotSpeed** 即可调整旋转的速度  
    如 `poly.rotSpeed = 3;` 就是让框每步旋转3度

### 已知缺点
- 当在拐角移动时，可能穿过拐角（不会出框，原本是要绕过去）
- 只能限制点（对于较小的物体实际上也可以当成一个点）
- 编辑不便
- 使用多个框时，如果两个框有两条边比较近，但是没有合并在一起  
玩家移动时也有可能跨越这两个多边形
