-- 这里是BagPanel面板的挂载脚本
-- 而我们的背包面板，无非就是要完成以下功能：
    -- a. 监听 退出按钮
    -- b. 监听页签的切换
    -- c. 更新道具信息（读取玩家数据;读取子对象Content并为其添加“格子”子对象）

-- 1. 一个面板对应一个表
BagPanel = {}

-- 2. "声明"所谓的“成员变量”
-- 面板对象
BagPanel.panelObj = nil
-- 面板对象的各个控件
BagPanel.btnClose = nil
BagPanel.togEquip = nil
BagPanel.togItem = nil
BagPanel.togGem = nil
BagPanel.svBag = nil
BagPanel.Content = nil

-- 存储当前页签所显示的格子
BagPanel.items = {}
-- 当前页签type（用于防止重复点击同一页签所造成的页签重复刷新）
BagPanel.nowType = -1


-- 3. "声明"所谓的“成员方法”
-- 面板初始化
function BagPanel:Init()
    if self.panelObj == nil then
        -- a. 实例化 面板对象
        self.panelObj = ABMgr:LoadRes("ui", "BagPanel", typeof(GameObject))
        self.panelObj.transform:SetParent(Canvas, false)

        -- b. 获取面板控件
        --  关闭按钮
        -- self.btnRole = self.panelObj.transform:Find("btnRole"):GetComponent((typeof(Button)))
        self.btnClose = self.panelObj.transform:Find("btnClose"):GetComponent((typeof(Button)))
        --  3个toggle
        local group = self.panelObj.transform:Find("Group")  
        if group then  
            self.togEquip = group:Find("togEquip"):GetComponent(typeof(Toggle))  
            self.togItem = group:Find("togItem"):GetComponent(typeof(Toggle)) 
            self.togGem = group:Find("togGem"):GetComponent((typeof(Toggle))) 
        end
        
        --  sv相关
        self.svBag = self.panelObj.transform:Find("svBag"):GetComponent((typeof(ScrollRect)))
        self.Content = self.svBag.transform:Find("Viewport"):Find("Content")

        -- c. 为控件添加事件
        self.btnClose.onClick:AddListener(function() self:HideMe() end)
        --- 单选框事件（切换页签）
        ---- 一般而言,Toggle类型 所对应的委托类型为 UnityAction<bool>,但是这里回调的是Lua方法
        self.togEquip.onValueChanged:AddListener(function(value)
            if value == true then
                self:ChangeType(1)
            end
        end)
        self.togItem.onValueChanged:AddListener(function(value)
            if value == true then
                self:ChangeType(2)
            end
        end)
        self.togGem.onValueChanged:AddListener(function(value)
            if value == true then
                self:ChangeType(3)
            end
        end)
    end
end
-- 面板的显隐
function BagPanel:ShowMe()
    self:Init()
    self.panelObj:SetActive(true)

    -- 初次打开背包时的内容/数据更新
    if self.nowType == -1 then
        self:ChangeType(1)
    end
end

function BagPanel:HideMe()
    self.panelObj:SetActive(false)
end


-- 处理页签切换逻辑(1-装备;2-道具;3-砖石)
function BagPanel:ChangeType(type)
    -- print("Oro测试：当前页签类型为："..type) -- 测试
    -- c. 判断是否切换到不同的页签（避免因重复点击同一页签造成的页签重复刷新）
    if self.nowType == type then
        return
    end
    
    -- 下面,我们来粗暴的处理“页签切换”逻辑
    -- a. 更新之前,删除原页签的内容
    for i = 1, #self.items do
        -- 销毁“格子”对象
        -- >> 面向对象的优化
        self.items[i]:Destroy()
        --[[
        GameObject.Destroy(self.items[i].obj)
        --]]
    end
    self.items = {} -- 清空表


    -- b. 根据当前页签类型,来创建新的内容/格子
    --- b1. 根据页签的type类型，来获取PlayerData中的数据
    local nowItems = nil
    if type == 1 then
        nowItems = PlayerData.equips
    elseif type == 2 then
        nowItems = PlayerData.items
    else
        nowItems = PlayerData.gems
    end
    --- b2. 创建“道具格子”
    for i = 1, #nowItems do
        -- >> 面向对象的优化
        -- 1> 根据数据,创建“道具格子”对象
        local grid = ItemGrid:new()
        -- 2> 实例化 对象, 并设置位置(math.floor(...)将浮点数结果向下取整到最接近的整数，这确保了行数的完整)
        grid:Init(self.Content, (i-1)%4*180 - 175*2, math.floor((i-1)/4)*(-180)+170*2)
        -- 3> 初始化对象信息,设置图标&数量
        grid:InitData(nowItems[i])

        --[[
        -- 虽然我们没有“格子面板”对象对应的表
        -- 但是我们有“格子面板”的资源,即 可以通过“格子面板”资源的加载,并更改其图标、文本、位置 即可

        -- 用一张新表 来代替单个“格子面板”,存储其属性
        local grid = {}
        grid.obj = ABMgr:LoadRes("ui", "ItemGrid", typeof(GameObject))
        -- 设置父对象
        grid.obj.transform:SetParent(self.Content, false)
        -- 继续设置其位置，防止多个“格子”重叠
        grid.obj.transform.localPosition = Vector3((i-1)%4*175, math.floor((i-1)/4)*175, 0)
        -- 设置 图标&文本
        --- 获取 控件
        grid.imgIcon = grid.obj.transform:Find("imgIcon"):GetComponent(typeof(Image))
        grid.Text = grid.obj.transform:Find("Text (Legacy)"):GetComponent(typeof(Text))
        --- 设置图标
        ---- 通过PlayerData中的道具ID,获取 图标信息
        local data = ItemData[nowItems[i].id]
        ---- 根据data加载图集，再加载其图标
        local strs = string.split(data.icon, "_")
        local spriteAtlas = ABMgr:LoadRes("ui", strs[1], typeof(SpriteAtlas))
        grid.imgIcon.sprite = spriteAtlas:GetSprite(strs[2])
        --- 设置文本
        grid.Text.text = nowItems[i].num
        --]]--

        -- 存储到BagPanel.items表中
        table.insert(self.items, grid)
    end
end