local UITest = {}

UITest.panelObj = nil -- 关联的面板对象
UITest.btnRole = nil
UITest.btnCharacter = nil

UITest.scrollList = nil -- LoopScrollRectEx 组件引用
UITest.testData = {}    -- 测试数据

function UITest:Show()
    self:InstantiateUI()  -- 实例化面板
    self:InitUI()         -- 初始化面板控件

    self:InitScrollList() -- 初始化滚动列表
end

function UITest:InstantiateUI()
    print("lyk InstantiateUI called")
    self.panelObj = ABManager:ResourcesLoad("Prefabs/UI/UITest", typeof(GameObject)) -- 这里的`self.`代指“调用者”(谁调用这个方法，self就代表谁)
    self.panelObj.transform:SetParent(CanvasLow, false)
end

function UITest:InitUI()
    self.btnRole = self.panelObj.transform:Find("btnRole"):GetComponent(typeof(Button))
    self.btnCharacter = self.panelObj.transform:Find("btnCharacter"):GetComponent(typeof(Button))
    -- 为按钮添加点击事件监听
    self.btnRole.onClick:AddListener(function() self:OnBtnRoleClick() end)
    self.btnCharacter.onClick:AddListener(function() self:OnBtnCharacterClick() end)

    -- 获取 LoopScrollRectEx 组件（挂载在 Scroll View 节点上）
    self.scrollList = self.panelObj.transform:Find("LoopScrollRectEx"):GetComponent(typeof(CS.LoopScrollRectEx))

    -- -- 初始化滚动列表
    -- self.scrollList.itemPrefab = self.panelObj.transform:Find("LoopScrollRectEx/Scroll View/Viewport/Content/Item")
    --     .gameObject
end

function UITest:InitScrollList()
    --初始化测试数据
    self.testData = {}
    for i = 1, 100 do
        table.insert(self.testData, "lyk " .. i)
    end

    self.scrollList:Init(self.GetItemData, self.OnItemUpdate)
end

-- 定义的独立函数
function UITest.GetItemData(index)
    return UITest.testData[index + 1]
end

function UITest.OnItemUpdate(go, index, data)
    local text = go.transform:Find("Text"):GetComponent(typeof(CS.TMPro.TextMeshProUGUI))
    text.text = data
end

function UITest:Hide()
    UIManager.HidePanel("UITest") -- 调用UIManager隐藏面板
end

function UITest:OnBtnRoleClick()
    print("lyk BtnRole clicked")
    local isActive = self.scrollList.gameObject.activeSelf
    self.scrollList.gameObject:SetActive(not isActive)

    -- 这里可以添加按钮点击后的逻辑
end

function UITest:OnBtnCharacterClick()
    print("lyk BtnCharacter clicked")
    -- 这里可以添加按钮点击后的逻辑
end

return UITest
