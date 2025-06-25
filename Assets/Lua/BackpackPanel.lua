-- 这里是BackpackPanel面板的挂载脚本
PlayerBackpack = {}
PlayerBackpack.packs = { [1] = {id = 101, num = "1*1"}}
PlayerBackpack.equipments = {}
PlayerBackpack.nearbyItems = {}

PlayerBackpack.packBoxs = {[1]={-1,-1,-1,-1,-1,-1},[2]={-1,-1,-1,-1,-1,-1}}
PlayerBackpack.equipmentBoxs= {[1]={-1,-1,-1,-1,-1,-1},[2]={-1,-1,-1,-1,-1,-1},
                                [3]={-1,-1,-1,-1,-1,-1},[4]={-1,-1,-1,-1,-1,-1}}
-- PlayerBackpack.nearbyItemBoxs = {[1]={-1,-1,-1,-1,-1,-1,0},[2]={-1,-1,-1,-1,-1,-1,0},[3]={0,0,0,0,0,0,0}}
PlayerBackpack.nearbyItemBoxs = {[1]={-1,-1,-1,-1,-1,-1},[2]={-1,-1,-1,-1,-1,-1},
                                [3]={-1,-1,-1,-1,-1,-1},[4]={-1,-1,-1,-1,-1,-1},
                                [5]={-1,-1,-1,-1,-1,-1},[6]={-1,-1,-1,-1,-1,-1},
                                [7]={-1,-1,-1,-1,-1,-1}}
PlayerBackpack.A = {[1]={1}}
PlayerBackpack.B = {[1]={1,1},[2]={-1,1}}
PlayerBackpack.C = {[1]={1,1}}

-- 1. 一个面板对应一个表
BackpackPanel = {}

-- 2. "声明"所谓的“成员变量”
-- 面板对象
BackpackPanel.panelObj = nil
BackpackPanel.BackpackBackgroundImg = nil
-- 面板对象的各个控件
BackpackPanel.butQuit = nil

BackpackPanel.equipment = nil -- 挂载装备
BackpackPanel.pack = nil -- 收纳背包
BackpackPanel.nearbyItem = nil -- 附近物品


-- 3. "声明"所谓的“成员方法”
-- 面板初始化
function BackpackPanel:Init()  
    if self.panelObj == nil then  
        -- 实例化 面板对象  
        self.panelObj = ABMgr:LoadRes("ui", "BackpackPanel", typeof(GameObject))  
        self.panelObj.transform:SetParent(Canvas, false)  
  
        -- 获取面板控件  
        self.BackpackBackgroundImg = self.panelObj.transform:Find("BackpackBackgroundImg")  
        if self.BackpackBackgroundImg then  
            -- 获取关闭按钮  
            -- local btnQuitTransform = self.BackpackBackgroundImg.transform:Find("btnQuit")
            -- local btnQuitTransform = self.panelObj.transform:Find("butQuit")
            local btnQuitTransform = self.BackpackBackgroundImg:Find("butQuit")
            if btnQuitTransform then  
                self.btnQuit = btnQuitTransform:GetComponent(typeof(Button))  
                if self.btnQuit then  
                    self.btnQuit.onClick:AddListener(function() self:HideMe() end)  
                else  
                    print("Error: btnQuit component not found.")  
                end  
            else  
                print("Error: btnQuit not found under BackpackBackgroundImg.")  
            end  
        else  
            print("Error: BackpackBackgroundImg not found.")  
        end

        self.equipment = self.panelObj.transform:Find("objA")
        self.pack = self.panelObj.transform:Find("objB")
        self.nearbyItem = self.panelObj.transform:Find("objC")
    end  
end
-- 面板的显隐
function BackpackPanel:ShowMe()
    self:Init()
    self.panelObj:SetActive(true)
    -- print("111 111") --【测试】
    self:UpdatePanel()
end

function BackpackPanel:HideMe()
    self.panelObj:SetActive(false)
end

function BackpackPanel:UpdatePanel()
    self:UpdateNearbyItems()
end


function BackpackPanel:UpdateNearbyItems()  
    -- Print a debug message (remove or replace in production code)  
    print("Updating nearby items")
    print("[BackpackPanel:UpdateNearbyItems] #PlayerBackpack.nearbyItems = " ..  #PlayerBackpack.nearbyItems)

    -- 销毁所有现有的“格子”对象  
    for i = 1, #PlayerBackpack.nearbyItems do 
        PlayerBackpack.nearbyItems[i]:Destroy()  
    end  
    PlayerBackpack.nearbyItems = {} -- 清空表
    PlayerBackpack.nearbyItemBoxs = {}
    PlayerBackpack.nearbyItemBoxs = {[1]={-1,-1,-1,-1,-1,-1},[2]={-1,-1,-1,-1,-1,-1},
                                    [3]={-1,-1,-1,-1,-1,-1},[4]={-1,-1,-1,-1,-1,-1},
                                    [5]={-1,-1,-1,-1,-1,-1},[6]={-1,-1,-1,-1,-1,-1},
                                    [7]={-1,-1,-1,-1,-1,-1}}
  
    local cubeNames = LuaUpdate.cubeNames  
    -- 用cube名称填充nearbyItems表  
    for index, name in ipairs(cubeNames) do  
        -- print("[" .. index .. "] Found Cube: " .. name)  
        local grid = ItemsTest:new()  
        local gridType = grid:GetType(name) -- 确保这个方法返回了一个有效的gridType  
        local wosList = GetWos(gridType) -- GetWos现在返回一个表的列表  
  
        if #wosList > 0 then -- 检查是否找到了至少一个空位  
            local wos = wosList[1] -- 获取第一个空位  
            local x = wos.x  
            local y = wos.y
            -- print("wos.x = " .. wos.x .. "; wos.y = " .. wos.y)
            grid.name = grid:GetItemsName(name)
            grid:Init(self.nearbyItem, (x-1)*70, -(y-1)*70, grid.name, wos.x, wos.y, "objC") -- 使用空位的坐标初始化grid  
            table.insert(PlayerBackpack.nearbyItems, grid)  
        else  
            print("No valid position found for grid type: " .. gridType)  
        end  
    end 
    print("222 222 cubeNames 长度= " .. #cubeNames) --【测试】

end

-- 自动放置ABC道具在objC中的位置
function  GetWos(gridType)
    local wos = {}  -- 用于存储所有符合条件的空位[行列式位置：7行6列]
    local XY_Pos = {} -- XY坐标系的位置（用于坐标转换）
    local found = false  -- 标记是否找到了至少一个空位
    local sum = 0
    if (gridType == "B") or (gridType == "C") then
        sum = 1
    end
    -- print("[GetWos] #PlayerBackpack.nearbyItemBoxs = " .. #PlayerBackpack.nearbyItemBoxs .. "; #PlayerBackpack.nearbyItemBoxs[1] = " .. #PlayerBackpack.nearbyItemBoxs[1])

    for i = 1, #PlayerBackpack.nearbyItemBoxs - sum do    
        for j = 1, #PlayerBackpack.nearbyItemBoxs[i] - sum do    
            -- 减1是因为对于B和C类型，我们需要检查j+1，所以要确保j不会达到表的末尾  
            if gridType == "A" and PlayerBackpack.nearbyItemBoxs[i][j] == -1 then    
                table.insert(wos, {x = i, y = j})    
                found = true
                -- 更新PlayerBackpack.nearbyItemBoxs格子框占位信息
                PlayerBackpack.nearbyItemBoxs[i][j] = 1
                -- print("[GetWos] [A]PlayerBackpack.nearbyItemBoxs[" .. i .. "],["..j.."] = 1" )
                table.insert( XY_Pos, {x = j, y = i})
                return XY_Pos
            elseif gridType == "B" and PlayerBackpack.nearbyItemBoxs[i][j] == -1 and    
                                   j < #PlayerBackpack.nearbyItemBoxs[i] and  -- 确保j+1不会越界  
                                   PlayerBackpack.nearbyItemBoxs[i][j+1] == -1 and    
                                   i < #PlayerBackpack.nearbyItemBoxs and  -- 确保i+1不会越界（虽然这里i不会改变，但为安全起见）  
                                   PlayerBackpack.nearbyItemBoxs[i+1] and  -- 确保i+1的表存在  
                                   PlayerBackpack.nearbyItemBoxs[i+1][j+1] == -1 then    
                table.insert(wos, {x = i, y = j})    
                found = true
                PlayerBackpack.nearbyItemBoxs[i][j] = 1
                PlayerBackpack.nearbyItemBoxs[i][j+1] = 1
                PlayerBackpack.nearbyItemBoxs[i+1][j+1] = 1
                -- print("[GetWos] [B]PlayerBackpack.nearbyItemBoxs[" .. i .. "],["..j.."] = 1" )
                table.insert( XY_Pos, {x = j, y = i})
                return XY_Pos
            elseif gridType == "C" and PlayerBackpack.nearbyItemBoxs[i][j] == -1 and    
                                   j < #PlayerBackpack.nearbyItemBoxs[i] and  -- 确保j+1不会越界  
                                   PlayerBackpack.nearbyItemBoxs[i][j+1] == -1 then    
                table.insert(wos, {x = i, y = j})    
                found = true
                PlayerBackpack.nearbyItemBoxs[i][j] = 1
                PlayerBackpack.nearbyItemBoxs[i][j+1] = 1
                -- print("[GetWos] [C]PlayerBackpack.nearbyItemBoxs[" .. i .. "],["..j.."] = 1" )
                table.insert( XY_Pos, {x = j, y = i})
                return XY_Pos
            end    
        end    
    end    
  
    if not found then    
        print("该背包暂时没有位置了")    
        return {x = 0, y = 0}    
    else    
        return wos    
    end
end

function SetLocationNo(obj, type, wosX, wosY)
    if type == "A" then
        obj[wosX][wosY] = -1
    end

    if type == "B" then
        obj[wosX][wosY] = -1
        obj[wosX][wosY+1] = -1
        obj[wosX+1][wosY+1] = -1
    end

    if type == "C" then
        obj[wosX][wosY] = -1
        obj[wosX][wosY+1] = -1
    end
end
function SetLocationoFo(obj, type, wosX, wosY)
    if type == "A" then
        obj[wosX][wosY] = 1
    end

    if type == "B" then
        obj[wosX][wosY] = 1
        obj[wosX][wosY+1] = 1
        obj[wosX+1][wosY+1] = 1
    end

    if type == "C" then
        obj[wosX][wosY] = 1
        obj[wosX][wosY+1] = 1
    end
end