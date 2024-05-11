# CakeConnect
CakeConnect是一个以形状为主题的godot游戏习作，由四人接力编写。
# 故事背景

制作蛋糕总是会切出大量边角料，你要把形状各异的蛋糕边拼成一整个然后假装是正常的蛋糕卖掉，节约为上！

# 游戏流程

大厨不断地从传送带送过来各种形状的蛋糕，你要把它们摆在下面的盘子上组成完整的一圈蛋糕。

# 玩法设计

## 蛋糕形态

1. 所有蛋糕有着相同的边长，避免拼在一起出现长短不一的情况，增加无谓的难度。
2. 蛋糕尖角的角度：保持30、60、90。

## 游戏操作

玩家使用鼠标把蛋糕边从传送带拿下来并放置在下方的空白区域，靠近其他蛋糕时，会主动将蛋糕边吸附在离鼠标较近的其他蛋糕的边上，这时可以用快捷键（比如w和s或者上下键）旋转蛋糕，使其符合想放的方向，松开左键之后蛋糕自动吸附并防止，不可再更改位置。当有一点周围所有的蛋糕角凑够360°，就认为这块蛋糕拼成功了，消除并可以卖钱获取收益。

## 后期可以加的小要素

可以在蛋糕上添加樱桃等其他口味元素，作为增加得分的点，或者出现布丁这类软的可以适配任何形状的道具。 售卖获得的金币可以做什么用？

# 任务分配

## 合作方式
轮流方式，一人3天，共12天
6-8 zhufree 9-11 瓜 12-14 ionic 15-17 窝窝头

## 任务分解
1. 游戏基础设置：界面尺寸、分区（哪里是传送带哪里是盘子），蛋糕边长的设计，键位（顺时针、逆时针、暂停）（zhufree）
2. 蛋糕部分的制作：蛋糕的几种不同形状，物理体、精灵（zhufree）。
	1. ？蛋糕立体感部分（ionic）
3. 盘子的制作，盘子物理体和蛋糕不能出界的判定（zhufree）
4. 鼠标拖拽的功能：拿起和放下，放下时判定不可以有边出界，否则失败一次（zhufree）
5. 传送带，包括传送带的移动、蛋糕掉下去的动画和判定，血量条，失败判定（瓜）
6. 吸附（zhufree和ionic一起想，zhufree没做完的ionic做）
7. 旋转功能（ionic）
8. 消除的判定、得分计算（ionic）
9. 游戏结束的弹出界面，暂停和重新开始游戏（窝窝头）
10. 任何新发现的任务可以交给ionic和窝窝头做

### 任务难点和现在想到的解决方案
1. 吸附：目前想到的是：设计每个角点都有一个吸附距离的判定，符合距离要求就让鼠标拿的块向这边靠近
2. 旋转：用快捷键旋转边，给边编号，每按一次就换一个边对过去。松手确认。
3. 360度判定：给每个角都做一块物理体，可重合的，标明这个角度是多少。如果互相进入，就算它们的总和，总数加起来=360就算消除。

## 编写风格指南
[https://docs.godotengine.org/zh-cn/4.x/tutorials/scripting/gdscript/gdscript_styleguide.html]
* 文件名采用蛇形命名，类和节点采用驼峰命名，函数、变量、信号采用蛇形命名，常量采用蛇形命名大写
* 代码顺序
```
01. @tool
02. class_name
03. extends
04. # docstring

05. signals
06. enums
07. constants
08. @export variables
09. public variables
10. private variables
11. @onready variables

12. optional built-in virtual _init method
13. optional built-in virtual _enter_tree() method
14. built-in virtual _ready method
15. remaining built-in virtual methods
16. public methods
17. private methods
18. subclasses
```
1. 先写信号和属性，然后再写方法。
2. 先写公共成员，然后再写私有成员。
3. 先写虚函数回调，然后再写类的接口。
4. 先写对象的构造函数和初始化函数 _init 和 _ready ，然后再写修改对象的函数。

