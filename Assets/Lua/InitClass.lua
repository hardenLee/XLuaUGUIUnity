-- 为 常用类 取别名

-- 1.自定义的Lua类
-- **执行**自定义的Lua类，方便后期直接调用它们名下的方法
-- 面向对象Object.lua
require("Core/Object")
-- 字符串拆分 SplitTools.lua
require("Utils/SplitTools")
-- Json解析
Json = require("Utils/JsonUtility")

-- 2.Unity自带C#类
GameObject = CS.UnityEngine.GameObject
Transform = CS.UnityEngine.Transform
RectTransform = CS.UnityEngine.RectTransform
Resources = CS.UnityEngine.Resources

-- 获取Unity的Lua接口
Collider = CS.UnityEngine.Collider
Physics = CS.UnityEngine.Physics

TextAsset = CS.UnityEngine.TextAsset

-- 图集对象
SpriteAtlas = CS.UnityEngine.U2D.SpriteAtlas
-- 向量
Vector3 = CS.UnityEngine.Vector3
Vector2 = CS.UnityEngine.Vector2

-- UI相关
UI = CS.UnityEngine.UI
Image = UI.Image
Button = UI.Button
Text = UI.Text
Toggle = UI.Toggle
ScrollRect = UI.ScrollRect

-- 3.自定义的C#类
ABManager = CS.ABManager.Instance()    -- 直接得到AB包加载管理器器的单例对象
LuaCallPhysics = CS.LuaCallPhysics
LoopScrollRectEx = CS.LoopScrollRectEx -- 循环滚动视图组件

-- 补充-获取Canvas对象.位置
-- 方面在MainPanel等面板类直接设置父对象（仅在这里获取一次Canvas即可，避免多次重复获取）
Canvas = GameObject.Find("Canvas").transform
CanvasLow = GameObject.Find("Low").transform
CanvasMid = GameObject.Find("Mid").transform
CanvasHigh = GameObject.Find("High").transform


-- 4.管理器类
UIManager = require("Manager/UIManager") -- UI管理器
