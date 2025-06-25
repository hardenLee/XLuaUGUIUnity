-- 将Jaon文件数据 读取到Lua的表类型变量中

-- 1.将 ItemData.json 从AB包中加载出来
--  加载的json文件 所存储的 TextAsset对象
--local txt = ABMgr:LoadRes("json", "ItemData", typeof(CS.UnityEngine.TextAsset))
local txt = ABMgr:ResourcesLoad("Json/ItemData", typeof(CS.UnityEngine.TextAsset)) -- 这里的`ABMgr:ResourcesLoad`是一个自定义的加载方法

--- print(txt.text)-- 测试

-- 2. 获取txt的文本信息，并进行解析
local itemList = Json.decode(txt.text)
--- print(itemList[1].id .. " " .. itemList[1].name)-- 测试

-- 又因为这里加载出来的是一个*数组*结构的数据
-- 不方便通过 itemId 来获取数据里面的内容
-- 所以，我们使用一张*新表*进行一次*转存*，同时这一张*新表*在任何地方都可能被调用

-- 3. 一张以“键值对”形式存储 道具信息的表（key-道具ID，value-道具表内容）
ItemData = {}

-- 通过for遍历itemList，其中 下标为_(不重要)，值为value
for _, value in pairs(itemList) do
    -- ItemDat新建一个键为value.id，值为value的元素
    ItemData[value.id] = value
end
-- 测试
-- for key,value in pairs(ItemData) do
--     print(key,value)
-- end
