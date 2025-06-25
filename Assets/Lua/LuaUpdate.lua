LuaUpdate = {}

LuaUpdate.frameCount = 0  -- 将 luaUpdate 移到 LuaUpdate 表中
LuaUpdate.cubeNames = {}
LuaUpdate.isArchitecture = false

-- 初始化代码 【测试】
function LuaUpdate:Init()
    print("LuaUpdate initialized successfully")
    print(type(LuaUpdate)) 
end

--- 寻找玩家对象，并更新周围物体名称列表（范围检测）
function LuaUpdate:FindPlayer()
    local playerGameObject = GameObject.Find("Player")
    -- if playerGameObject and playerGameObject.transform then  
    --     local playerTransform = playerGameObject.transform
    if playerGameObject and playerGameObject:GetComponent(typeof(Transform))  then  
        local playerTransform = playerGameObject.transform

        -- 定义一个搜索半径  
        local radius = 2

        -- 调用函数检测Cube  
        -- local cubeNames = self:DetectCubesAroundPlayer(playerTransform.position, radius)

        -- local cubeNames = self:DetectCubesAroundPlayerTest(playerTransform, radius)

        self.cubeNames = self:LuaCallPhysicsTest(playerTransform, radius)

        -- 打印找到的Cube的名字  
        for _, name in ipairs(self.cubeNames) do  
            -- print("Found Cube: " .. name) 
        end
    else
        print("Player GameObject or its transform is not found") 
    end

end

--- Lua端调用Physics.OverlapSphereNonAlloc() 【测试：以弃用】
function LuaUpdate:DetectCubesAroundPlayer(playerTransform, radius)
    -- 创建一个空的数组来存储找到的Cube的名字  
    local cubeNames = {}
    print("222") --【测试】

    -- 使用Physics.OverlapSphereNonAlloc来查找玩家周围的对象  
    -- 假设你有一个Collider组件在玩家对象上 
    local maxColliders = 100
    local colliders = {}
    for i = 1, maxColliders do  
        table.insert(colliders, Collider())  
    end
    local numColliders = Physics.OverlapSphereNonAlloc(playerTransform, radius, colliders)
    -- print("numColliders = " .. numColliders) --【测试】

    -- 遍历所有找到的Collider  
    for _, collider in ipairs(colliders) do  
        if collider ~= nil then
            -- print("333") --【测试】
            -- 获取Collider对应的GameObject  
            local gameObject = collider:GetComponent("gameObject")

            -- 检查这个GameObject的标签是否是"TestCube"    
            if gameObject and gameObject:CompareTag("TestCube") then  
                table.insert(cubeNames, gameObject.name)
                -- print("444") --【测试】
            end

        end
    end

    -- 返回找到的Cube的名字数组  
    return cubeNames
end

-- LuaUpdate:Update() C#调用Lua方法的接口
function CsherpCallUpdate()
    LuaUpdate:Update()
end

-- Lua端的 帧更新 函数
function LuaUpdate:Update()
    self:FindPlayer() -- 更新BackpackPanel的道具信息（读取玩家附近道具
    if self.isArchitecture and self.grid then  
        self:FollowMouseTest()
        self:isMouseOnClick()-- 监听玩家点击
    elseif self.isArchitecture and not self.grid then  
        print("LuaUpdate.grid is nil, cannot call FollowMouse.")  
    end

end

--- Lua端调用Physics.OverlapSphereNonAlloc() 【测试：以弃用】
function LuaUpdate:DetectCubesAroundPlayerTest(playerTransform, radius)
    print("playerTransform.position" .. type(playerTransform.position) .. tostring(playerTransform.position)) --【测试】
    print("radius" .. type(radius) .. tostring(radius)) --【测试】

    -- 创建一个空的数组来存储找到的Cube的名字  
    local cubeNames = {}  
    print("222") -- 测试  
  
    -- 使用Physics.OverlapSphereNonAlloc来查找玩家周围的对象  
    -- 不需要预先创建Collider实例，直接传递一个空表
    local maxColliders = 50
    local colliders = {}
    for i = 1, maxColliders do  
        -- table.insert(colliders, Collider())
        table.insert(colliders, nil) -- 在Lua中，nil表示空值，用于初始化数组元素
    end
    local numColliders = Physics.OverlapSphereNonAlloc(playerTransform.position, radius, colliders)  ---【为什么在Lua中调用Unity的API，会出现莫名的错误？】
    print("numColliders = " .. numColliders) -- 测试  
  
    -- 遍历所有找到的Collider  
    for i = 1, numColliders do  
        local collider = colliders[i] -- Lua数组从1开始，但XLua返回的数组实际上是C#数组，从0开始访问
        if collider then  
            print("Collider " .. i .. " is attached to object: " .. collider.gameObject.name)
            -- 输出 collider 的类型信息（注意：这里不会直接显示 C# 类型，而是 Lua 中的表示）  
            print("Type of collider:", type(collider))  
            -- 尝试访问 gameObject（但在这里之前应该确保 collider 是有效的）  
            local gameObjectA = collider.gameObject 
  
            -- 检查这个GameObject的标签是否是"TestCube"  
            if gameObjectA and gameObjectA:CompareTag("TestCube") then  
                table.insert(cubeNames, gameObjectA.name)
                print("GameObject name:", gameObjectA.name)
            else  
                print("Error: GameObject tag is not 'TestCube' or gameObject is unexpectedly nil")
            end
        else  
            print("Error: collider should not be nil here (possible XLua binding issue)")  
        end  
    end  
  
    -- 返回找到的Cube的名字数组  
    return cubeNames  
end

--- Lua端回调C#代码，以实现Physics.OverlapSphereNonAlloc() 
function LuaUpdate:LuaCallPhysicsTest(playerTransform, radius) 
    local cubeNames = {}
    local center = playerTransform.position
    -- local radius = 2.0
 
    local colliders = {}
    for i = 1, 20 do 
        table.insert(colliders, nil) -- 在Lua中，nil表示空值，用于初始化数组元素
    end

    colliders = LuaCallPhysics.OverlapSphere(center, radius)  
 
    -- if colliders then  
    --     for i, collider in ipairs(colliders) do  
    --         if collider and collider.gameObject then  
    --             print("Detected object: " .. collider.gameObject.name)  
    --         end  
    --     end  
    -- else  
    --     print("OverlapSphere returned nil or not an array")  
    -- end

    -- 遍历所有找到的Collider  
    for i, collider in ipairs(colliders) do
        if collider and collider.gameObject then
            local gameObject = collider.gameObject
            -- print("[" .. i .. "]:Detected object: " .. collider.gameObject.name) 
            -- 检查这个GameObject的标签是否是"TestCube"    
            if gameObject and gameObject:CompareTag("TestCube") then  
                table.insert(cubeNames, gameObject.name)
            end
        end 
    end

    -- 返回找到的Cube的名字数组  
    return cubeNames
end

LuaUpdate.grid = nil
-- 选择道具后，更新状态，方便开启鼠标位置的追踪函数
function LuaUpdate:FollowMouse(name)
    LuaUpdate.isArchitecture = true
    -- if ItemsTest:new():InstantiatePrefabAtMousePosition(name) then
    if LuaUpdate.isArchitecture then
        LuaUpdate.grid = ItemsTest:new()
        LuaUpdate.grid:InstantiatePrefabAtMousePosition(name)
    else
        print("ItemsTest:new():InstantiatePrefabAtMousePosition(name) is nil")
    end
end

-- 跟踪/刷新 鼠标/道具位置
function LuaUpdate:FollowMouseTest()
    -- print("self.grid::" ..  tostring(self.grid)) 
    if self.isArchitecture and self.grid then  
        self.grid:FollowMouse() 
    else
        print("self.grid::" ..  tostring(self.grid))  
    end
    -- self.grid:FollowMouse()
end

-- 拖拽状态下，检测（帧更新）是否发现鼠标点击，以便确定拖拽道具的目标位置
function LuaUpdate:isMouseOnClick()
    if CS.UnityEngine.Input.GetMouseButtonDown(0) then
        LuaUpdate.isArchitecture = false

        local mouseDownUIPos = self.grid:GetMousePositionInUI()
        local gridName = self.grid.name
        local gridType = self.grid:GetType(gridName)
        -- print("[LuaUpdate:isMouseOnClick] ["..gridType.."] Name =".. tostring(gridName) ..", mouseDownUIPos.x = " .. mouseDownUIPos.x .. "; mouseDownUIPos.y = " .. mouseDownUIPos.y)
        self.grid:Destroy()

        local wos = {}
        if mouseDownUIPos.x < 30 then
            if mouseDownUIPos.y < 25 then
                if mouseDownUIPos.x > -450 and mouseDownUIPos.y > -250 and mouseDownUIPos.y < 25  then
                    print("mouseDownUIPos = B")
                    wos.x = math.floor((mouseDownUIPos.x + 450) / 70) + 1 
                    wos.y = 4 - (math.floor((mouseDownUIPos.y - 25) / 70) + 1 + 3)
                    print("[wos] wos.x = " .. wos.x .. "; wos.y = " .. wos.y)
                    local grid = ItemsTest:new() 
                    grid:Init(BackpackPanel.pack, (wos.x-1)*70, -(wos.y-1)*70, gridName, wos.x, wos.y, "objB")
                    table.insert(PlayerBackpack.equipments, grid) 
                    SetLocationoFo(PlayerBackpack.equipmentBoxs, gridType, wos.y, wos.x)
                else
                    wos = AutoArrange(gridType)
                    local grid = ItemsTest:new() 
                    grid:Init(BackpackPanel.nearbyItem, (wos.x-1)*70, -(wos.y-1)*70, gridName, wos.x, wos.y, "objC")
                    table.insert(PlayerBackpack.nearbyItems, grid) 
                    SetLocationoFo(PlayerBackpack.nearbyItemBoxs, gridType, wos.y, wos.x)
                end
            else
                if mouseDownUIPos.x > -450 and mouseDownUIPos.y > 110 and mouseDownUIPos.y <240  then
                    print("mouseDownUIPos = A")
                    wos.x = math.floor((mouseDownUIPos.x - 240) / 70) + 1 + 10
                    wos.y = 3- (math.floor((mouseDownUIPos.y - 110) / 70) + 1)
                    print("[wos] wos.x = " .. wos.x .. "; wos.y = " .. wos.y)
                    local grid = ItemsTest:new() 
                    grid:Init(BackpackPanel.equipment, (wos.x-1)*70, -(wos.y-1)*70, gridName, wos.x, wos.y, "objA")
                    table.insert(PlayerBackpack.packs, grid) 
                    SetLocationoFo(PlayerBackpack.packBoxs, gridType, wos.y, wos.x)
                else
                    wos = AutoArrange(gridType)
                    local grid = ItemsTest:new() 
                    grid:Init(BackpackPanel.nearbyItem, (wos.x-1)*70, -(wos.y-1)*70, gridName, wos.x, wos.y, "objC")
                    table.insert(PlayerBackpack.nearbyItems, grid) 
                    SetLocationoFo(PlayerBackpack.nearbyItemBoxs, gridType, wos.y, wos.x)
                end
            end
        else
            if mouseDownUIPos.x < 440 and mouseDownUIPos.y > -250 and mouseDownUIPos.y <240  then
                print("mouseDownUIPos = C")
                wos.x = math.floor((mouseDownUIPos.x - 30) / 70) + 1
                wos.y = 7- (math.floor((mouseDownUIPos.y - 240) / 70) + 2 + 5)
                print("[wos] wos.x = " .. wos.x .. "; wos.y = " .. wos.y)
                local grid = ItemsTest:new() 
                grid:Init(BackpackPanel.nearbyItem, (wos.x-1)*70, -(wos.y-1)*70, gridName, wos.x, wos.y, "objC")
                table.insert(PlayerBackpack.nearbyItems, grid) 
                SetLocationoFo(PlayerBackpack.nearbyItemBoxs, gridType, wos.y, wos.x)
            else
                wos = AutoArrange(gridType)
                local grid = ItemsTest:new() 
                grid:Init(BackpackPanel.nearbyItem, (wos.x-1)*70, -(wos.y-1)*70, gridName, wos.x, wos.y, "objC")
                table.insert(PlayerBackpack.nearbyItems, grid) 
                SetLocationoFo(PlayerBackpack.nearbyItemBoxs, gridType, wos.y, wos.x)
            end
        end
    end
end

-- 点击目标范围外，自动更新道具位置
function AutoArrange(gridType)
    local wosList = GetWos(gridType) -- GetWos现在返回一个表的列表
    local wos
  
    if #wosList > 0 then -- 检查是否找到了至少一个空位  
        wos = wosList[1] -- 获取第一个空位  
        local x = wos.x  
        local y = wos.y
        -- print("[AutoArrange] wos.x = " .. wos.x .. "; wos.y = " .. wos.y)
        return wos
    else  
        print("[AutoArrange] No valid position found for grid type: " .. gridType) 
        wos.x = 6
        wos.y = 6
        return wos 
    end
end