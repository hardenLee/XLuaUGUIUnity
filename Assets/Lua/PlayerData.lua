PlayerData = {}

-- 因为我们这里只需要*道具信息*，所以：
-- 装备数据
PlayerData.equips = {}
-- 道具数据
PlayerData.items = {}
-- 货币数据
PlayerData.gems = {}

-- 初始化(方便修改数据来源)
function PlayerData:Init()
    -- 玩家的背包信息，一般而言，都不会存储*所有的道具信息*，而是仅存储道具的部分关键信息（道具ID&数量）

    -- 这里直接写死数据，方便测试

    -- 往equips表里面 插入数据
    table.insert(self.equips,{id = 1001, num = 1})
    table.insert(self.equips,{id = 1002, num = 1})
    table.insert(self.equips,{id = 1003, num = 505})
    table.insert(self.equips,{id = 1004, num = 56})
    table.insert(self.equips,{id = 1006, num = 66})
    

    -- 往item表里面 插入数据
    table.insert(self.items,{id = 1004, num = 56})
    table.insert(self.items,{id = 1005, num = 39})
    table.insert(self.items,{id = 1001, num = 1})

    -- 往gems表里面 插入数据
    table.insert(self.gems,{id = 1006, num = 66})
    table.insert(self.gems,{id = 1007, num = 77})
end

PlayerData:Init()
-- print(PlayerData.items[1]) -- 测试
