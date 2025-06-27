-- 如果我们需要对“道具格子面板”进行面向对象的优化,那我们需要解决哪些问题？
-- 0. 继承Object
Object:subClass("ItemsTest")
--- "成员变量"
ItemsTest.obj = nil
ItemsTest.name = nil
ItemsTest.imgTest = nil
ItemsTest.btnTest = nil
ItemsTest.type = nil
ItemsTest.Pos = {}
--- "成员方法":

-- 1. 实例化 “道具格子面板”对象（主要就是优化BagPanel:ChangeType里面的逻辑）
--- father >> 父对象,相对于BagPanel.Content
--- posX、posY >> BagPanel:ChangeType里面用于计算“格子”位置的参数
function ItemsTest:Init(father, posX, posY, name, Pos_X, Pos_Y, objBox)
    -- self.name = self:GetItemsName(name)
    self.name = name
    table.insert(self.Pos, { x = Pos_X, y = Pos_Y, box = objBox })
    --self.obj = ABManager:LoadRes("items", name, typeof(GameObject))
    self.obj = ABManager:ResourcesLoad("items/" .. name, typeof(GameObject))

    if self.obj then
        -- 设置父级和位置
        self.obj.transform:SetParent(father, false)
        self.obj.transform.localPosition = Vector3(posX, posY, 0)

        -- self.imgTest = self.obj.transform:Find("imgTest_1_1"):GetComponent(typeof(Image))

        -- 获取Button组件并添加点击事件监听器
        self.btnTest = self.obj.transform:Find("btnTest"):GetComponent(typeof(Button))
        if self.btnTest then
            self.btnTest.onClick:AddListener(function()
                -- print(name .. "]wos.x = " .. posX .. "; wos.y = " .. posY)
                -- self:FollowingMouse(self:GetItemsName(name))
                -- self:InstantiatePrefabAtMousePosition(self:GetItemsName(name))
                self:Destroy()
                LuaUpdate:FollowMouse(self.name)
            end)
        end
    end
end

-- 2. 初始化 “道具格子”信息
--- data >> 道具的信息(道具ID&数量)
function ItemsTest:InitData(data)
    -- 设置图标
    -- 通过PlayerData中的道具ID,获取 图标信息
    local itemdata = ItemData[data.id]
    -- 根据data加载图集，再加载其图标
    local strs = string.split(itemdata.icon, "_")
    --local spriteAtlas = ABManager:LoadRes("ui", strs[1], typeof(SpriteAtlas))
    local spriteAtlas = ABManager:ResourcesLoad("SpriteAltas/" .. strs[1], typeof(SpriteAtlas))
    self.imgIcon.sprite = spriteAtlas:GetSprite(strs[2])
    -- 设置文本
    self.Text.text = data.num
end

-- 3. 添加一些独属于“道具格子对象”的逻辑（悬停监听）
--- 删除 “格子”对象
function ItemsTest:Destroy()
    self:ResetLocation()
    GameObject.Destroy(self.obj)
    self.obj = nil
end

function ItemsTest:GetType(name)
    if name == "Cube_TestObj_A" or name == "objTest_1_1" then
        return "A"
    end
    if name == "Cube_TestObj_B" or name == "objTest_2_2" then
        return "B"
    end
    if name == "Cube_TestObj_C" or name == "objTest_1_2" then
        return "C"
    end
end

function ItemsTest:GetItemsName(name)
    if name == "Cube_TestObj_A" then
        return "objTest_1_1"
    end
    if name == "Cube_TestObj_B" then
        return "objTest_2_2"
    end
    if name == "Cube_TestObj_C" then
        return "objTest_1_2"
    end
end

function ItemsTest:FollowingMouse(name)
    self:Destroy()

    -- 获取预制体并初始化
    --local prefab = ABManager:LoadRes("items", name, typeof(GameObject))
    local prefab = ABManager:ResourcesLoad("items/" .. name, typeof(GameObject))

    if not prefab then
        error("Prefab not found at path: AB/items/" .. name)
    end

    -- 获取鼠标在 UI 空间下的坐标（0-1 范围）
    local rectTransformUtility = CS.UnityEngine.RectTransformUtility
    local mousePosition = CS.UnityEngine.Input.mousePosition
    local canvasTransform = Canvas:GetComponent(typeof(RectTransform)) -- 您需要获取 Canvas 的 RectTransform 引用
    -- print("[mousePosition] mousePosition.x = " .. mousePosition.x .. "; mousePosition.y = " .. mousePosition.y)

    -- 将屏幕坐标转换为 UI 坐标
    local localPoint = CS.UnityEngine.Vector2.zero
    if rectTransformUtility.ScreenPointToLocalPointInRectangle(canvasTransform, mousePosition, localPoint) then
        print("[localPoint] localPoint.x = " .. localPoint.x .. "; localPoint.y = " .. localPoint.y)
        -- 实例化预制体
        -- local followingObject = CS.UnityEngine.GameObject.Instantiate(prefab)
        local followingObject = prefab
        -- followingObject.transform.SetParent(Canvas, false)

        -- 如果存在跟随的预制体实例
        if followingObject then
            -- 设置预制体实例的位置为鼠标在 UI 空间下的位置
            -- 注意：这里假设你的预制体是一个 UI 元素，比如 Image 或 Button
            local uiElement = followingObject:GetComponent(CS.UnityEngine.RectTransform)
            -- 设置 UI 元素的位置为转换后的 UI 坐标
            uiElement.anchoredPosition = localPoint

            -- followingObject.transform.localPosition = Vector3(mousePosition.x, mousePosition.y, 0)
        else
            -- 如果预制体不是 UI 元素，则可能需要设置其世界坐标（但这通常不适用于 UI 元素）
            -- 注意：下面的代码是错误的，因为您不能直接将屏幕坐标用作世界坐标
            -- followingObject.transform.position = CS.UnityEngine.Camera.main.ScreenToWorldPoint(mousePosition)
            error("Prefab is not a UI element and does not have a RectTransform component")
        end
    else
        print("Failed to convert screen point to local point in rectangle")
    end

    -- -- 如果存在跟随的预制体实例
    -- if prefab then
    --     -- 设置预制体实例的位置为鼠标位置
    --     prefab.transform.position = CS.UnityEngine.Camera.main.ScreenToWorldPoint(mousePosition)
    -- end
end

-- 获取鼠标在UI中的位置
function ItemsTest:GetMousePositionInUI()
    local rectTransform = Canvas:GetComponent(typeof(RectTransform))
    if not rectTransform then
        print("rectTransform not found!")
        return nil
    end
    local worldCamera -- = GameObject.Find("Canvas"):GetComponent(typeof(Canvas)).worldCamera
    local canvasGameObject = GameObject.Find("Canvas")
    if canvasGameObject then
        -- 注意：这里应该使用XLUA提供的方式来获取Canvas类型，但在这个例子中，我们假设
        -- 'Canvas'类型已经通过某种方式在Lua中可用，或者XLUA允许直接使用字符串"Canvas"
        -- 来获取组件。实际情况可能取决于你的XLUA集成。
        local canvas = canvasGameObject:GetComponent(typeof(CS.UnityEngine.Canvas))
        if canvas then
            -- if canvas.renderMode == CS.UnityEngine.Canvas.RenderMode.WorldSpace then
            local worldCamera = canvas.worldCamera
            -- 使用worldCamera做某事
            -- else
            -- print("Canvas的Render Mode不是World Space。")
            -- end
        else
            print("未能从Canvas GameObject中获取Canvas组件。")
        end
    else
        print("未能找到名为'Canvas'的GameObject。")
    end


    local mousePos = CS.UnityEngine.Input.mousePosition
    local outPosition = Vector2.zero -- 注意这里是Vector2

    -- print("[mousePos] mousePos.x = " .. mousePos.x .. "; mousePos.y = " .. mousePos.y)
    -- print("[rectTransform] rectTransform = " .. tostring(rectTransform or "nil"))
    -- print("[worldCamera] worldCamera = " .. tostring(worldCamera or "nil"))

    -- 转换鼠标的屏幕坐标到Canvas的本地坐标
    local success, outPositions = CS.UnityEngine.RectTransformUtility.ScreenPointToLocalPointInRectangle(
        rectTransform,
        CS.UnityEngine.Vector2(mousePos.x, mousePos.y), -- 确保z值存在，虽然对于屏幕坐标通常不重要
        worldCamera,
        outPosition
    )


    -- if CS.UnityEngine.RectTransformUtility.ScreenPointToLocalPointInRectangle(rectTransform, mousePos, CS.UnityEngine.Camera.main, outPosition) then
    if success then
        -- outPosition
        -- print("[outPositions] x = " .. outPositions.x .. ", y = " .. outPositions.y)
        -- print("[outPosition] outPosition[1] = " .. outPositions[1] )
        -- print("[outPosition] outPosition[0] = " .. outPositions[0] )
        -- for i,outPosition in ipairs(outPositions) do
        --     print("[outPosition] outPosition[" ..i.. "] = " .. outPosition)
        -- end
        return outPositions
    else
        return nil
    end
end

-- 在鼠标位置实例化预制体
function ItemsTest:InstantiatePrefabAtMousePosition(name)
    -- self:Destroy()
    self.name = name

    local mousePosition = self:GetMousePositionInUI()
    -- print("[mousePos] mousePosition.x = " .. mousePosition.x .. "; mousePosition.y = " .. mousePosition.y)

    if mousePosition then
        --local instance = ABManager:LoadRes("items", name, typeof(GameObject))
        local instance = ABManager:ResourcesLoad("items/" .. name, typeof(GameObject))
        if instance then
            local canvas = GameObject.Find("Canvas")
            if canvas then
                instance.transform:SetParent(canvas.transform, false)
                instance.transform.localPosition = Vector3(mousePosition.x, mousePosition.y, 0)
                -- instance.transform:GetComponent(typeof(RectTransform)).anchoredPosition = mousePosition
                self.obj = instance
                return instance
            end
        end
    end
    return nil
end

function ItemsTest:FollowMouse()
    local mousePosition = self:GetMousePositionInUI()

    self.obj.transform.localPosition = Vector3(mousePosition.x, mousePosition.y, 0)
end

-- table.insert(self.Pos, {x = Pos_X, y = Pos_Y, box = objBox})
function ItemsTest:ResetLocation()
    -- 判断是否进行了存储（有无更新Box行列式？）
    if not self.Pos then
        return
    end

    -- 判断该道具属于哪一个行列式？
    if self.Pos.box == "objA" then
        self:ResetLocationPos(PlayerBackpack.packBoxs)
    elseif self.Pos.box == "objB" then
        self:ResetLocationPos(PlayerBackpack.equipmentBoxs)
    elseif self.Pos.box == "objC" then
        self:ResetLocationPos(PlayerBackpack.nearbyItemBoxs)
    end
end

function ItemsTest:ResetLocationPos(obj)
    if self.type == "A" then
        obj[self.PosY][self.PosX] = -1
    end

    if self.type == "B" then
        obj[self.PosY][self.PosX] = -1
        obj[self.PosY][self.PosX + 1] = -1
        obj[self.PosY + 1][self.PosX + 1] = -1
    end

    if self.type == "C" then
        obj[self.PosY][self.PosX] = -1
        obj[self.PosY][self.PosX + 1] = -1
    end
end
