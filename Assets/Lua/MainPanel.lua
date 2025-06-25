-- 同理，这里的MainPanel面板同样是 通过**表**来形容“面板”对象的
-- So 只要是一个新的对象（面板），我们就需要新声明一张*表*

MainPanel = {} -- 1. 我们需要通过这一张“表”来 控制/监听 面板的事件&实例化


-- 2. 声明一些“关联变量”
-- 这只是为了方便理解 “我们要怎样将Lua脚本关联到Unity对象实体上”
-- （这不是必须的，因为Lua的特性 不存在“声明变量”的概念）
-- 同时，这样明确的写明可以方便了解该 类/表 中存在哪些变量
-- （相对于 利用“面向对象”的思想进行封装）
MainPanel.panelObj = nil -- 关联的面板对象
MainPanel.btnRole = nil  -- 对应的面板控件
MainPanel.btnCharacter = nil
MainPanel.btnMyCharacter = nil


-- 3. 初始化该面板（实现下述的需求）
function MainPanel:Init()
    -- 优化1：既然我们是通过SetActive()来控制面板显隐的，那么我们每一次调用Init()都会执行逻辑，这样子会不会出错？
    -- 所以我们对panelObj进行判断（仅当panelObj面板对象没有被初始化时才进行初始化逻辑）
    if self.panelObj == nil then
        -- a. 完成面板的实例化
        -- a1. 利用ABMgr加载AB包中的面板
        --self.panelObj = ABMgr:LoadRes("ui", "MainPanel", typeof(GameObject)) -- 这里的`self.`代指“调用者”(谁调用这个方法，self就代表谁)
        self.panelObj = ABMgr:ResourcesLoad("Prefabs/UI/MainPanel", typeof(GameObject)) -- 这里的`self.`代指“调用者”(谁调用这个方法，self就代表谁)

        -- a2. 设置面板父对象：Canvas（因为Canvas的使用频率非常的频繁，所以我们可以在InitClass的时候就获取它，以方便其他类的调用）
        self.panelObj.transform:SetParent(Canvas, false)

        -- b. 处理该面板的逻辑（按钮点击事件的监听&反应）

        -- b1. 找到对应控件对象：挂载的脚本（find找到子对象，再获取其挂载的脚本）
        self.btnRole = self.panelObj.transform:Find("btnRole"):GetComponent((typeof(Button)))
        self.btnCharacter = self.panelObj.transform:Find("btnCharacter"):GetComponent((typeof(Button)))
        self.btnMyCharacter = self.panelObj.transform:Find("btnMyCharacter"):GetComponent((typeof(Button)))
        -- print(self.btnRole) -- 测试

        -- b2. 为控件添加对应的事件（按钮点击事件的监听&反应）
        -- 这里的逻辑是为了显示“背包面板”（通过UGUI的`.onClick:AddListener()`方法添加事件）
        -- self.btnRole.onClick:AddListener(self.btnRoleClick)
        -- 如果直接通过`self.函数名()`传入监听函数，那么在监听函数内部就无非通过self来获取调用者对象
        self.btnRole.onClick:AddListener(function() self:btnRoleClick() end)
        self.btnCharacter.onClick:AddListener(function() self:btnCharacterClick() end)
        self.btnMyCharacter.onClick:AddListener(function() self:btnMyCharacterClick() end)
    end
end

-- 4. 显示&隐藏 面板
-- （同理，基于“面向对象”封装的思想，我们还需要处理一些‘成员函数’）
function MainPanel:ShowMe()
    -- 优化2：我们仅将ShowMe()作为面板显示的接口，仅在ShowMe()中进行初始化操作，而不再通过外部调用Init()
    self:Init()
    self.panelObj:SetActive(true)
end

function MainPanel:HideMe()
    self.panelObj:SetActive(false)
end

-- 5. 监听事件的回调函数
function MainPanel:btnRoleClick()
    -- print("btnRoleClick()被调用") -- 测试
    -- print(self.panelObj) -- 测试

    -- 这里无非就是处理背包面板的显示逻辑
    BagPanel:ShowMe()
end

function MainPanel:btnCharacterClick()
    BackpackPanel:ShowMe()
    --CreateObj()
end

function CreateObj()
    local go = GameObject("myLuaObj")
    go.transform:SetParent(Canvas.transform, false)
    go:AddComponent(typeof(CS.UnityEngine.UI.Image)) -- 添加Image组件
    print(go.name)                                   -- 测试
end

function MainPanel:btnMyCharacterClick()
    print("lyk btnMyCharacterClick()被调用") -- 测试
end
