local UIMain = {}

UIMain.panelObj = nil -- 关联的面板对象
UIMain.btnRole = nil
UIMain.btnCharacter = nil

function UIMain:Show()
    self:InstantiateUI() -- 实例化面板
    self:InitUI()        -- 初始化面板控件
end

function UIMain:InstantiateUI()
    print("lyk InstantiateUI called")
    self.panelObj = ABManager:ResourcesLoad("Prefabs/UI/UIMain", typeof(GameObject)) -- 这里的`self.`代指“调用者”(谁调用这个方法，self就代表谁)
    self.panelObj.transform:SetParent(Canvas, false)
end

function UIMain:InitUI()
    self.btnRole = self.panelObj.transform:Find("btnRole"):GetComponent(typeof(Button))
    self.btnCharacter = self.panelObj.transform:Find("btnCharacter"):GetComponent(typeof(Button))
    -- 为按钮添加点击事件监听
    self.btnRole.onClick:AddListener(function() self:OnBtnRoleClick() end)
    self.btnCharacter.onClick:AddListener(function() self:OnBtnCharacterClick() end)
end

function UIMain:Hide()
    UIManager.HidePanel("UIMain") -- 调用UIManager隐藏面板
end

function UIMain:OnBtnRoleClick()
    print("lyk BtnRole clicked")
    -- 这里可以添加按钮点击后的逻辑
end

function UIMain:OnBtnCharacterClick()
    print("lyk BtnCharacter clicked")
    -- 这里可以添加按钮点击后的逻辑
end

return UIMain
