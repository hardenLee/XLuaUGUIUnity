print("This is a project of Orokana, written in 2025, thank you for reading.((*/ω＼*))")
require("InitClass") -- 1.初始化常用类别名
print("o(*////▽////*)q! Lua 准备完毕! QwQ!")

require("Data/ItemData") -- 2.加载Jaon数据 到Lua中

-- 3. 获取 玩家信息
-- 3.1 从本地加载（本地存储的方法：PlayerPrefs; Json; 二进制）
-- 3.2 网络/服务器 加载
-- 3.3 直接在代码中写死
require("Data/PlayerData") -- 3.初始化玩家数据

-- 4. 执行 面板 逻辑
-- require("MainPanel")
-- require("BagPanel")
-- require("ItemGrid")
-- require("BackpackPanel")

require("Core/LuaUpdate")
-- LuaCallPhysics()
require("Data/ItemsTest")

-- MainPanel:Init() -- 参考MainPanel/优化2
--MainPanel:ShowMe()
LuaUpdate:Init()


UIManager:Init()

--UIManager:ShowPanel("UIMain")
UIManager:ShowPanel("UITest") -- 显示UITest面板


LuaUpdate:Update()
