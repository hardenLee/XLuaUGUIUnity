local UIMain = {}

UIMain.panelObj = nil -- 关联的面板对象
UIMain.btnRole = nil
UIMain.btnCharacter = nil

function UIMain:Show()
    self:InitUI() -- 初始化面板控件
end

function UIMain:InitUI()
    if not self.panelObj then
        error("UIMain.panelObj is nil! Did UIManager forget to instantiate it?")
        return
    end

    self.btnRole = self.panelObj.transform:Find("btnRole"):GetComponent(typeof(Button))
    self.btnCharacter = self.panelObj.transform:Find("btnCharacter"):GetComponent(typeof(Button))

    self.btnRole.onClick:AddListener(function() self:OnBtnRoleClick() end)
    self.btnCharacter.onClick:AddListener(function() self:OnBtnCharacterClick() end)
end

function UIMain:Hide()
    UIManager.HidePanel("UIMain") -- 调用UIManager隐藏面板
end

function UIMain:OnBtnRoleClick()
    print("lyk BtnRole clicked")
    UIManager:ShowPanel("UITest") -- 显示UITest面板
    -- 这里可以添加按钮点击后的逻辑
end

function UIMain:OnBtnCharacterClick()
    print("lyk BtnCharacter clicked")
    -- 这里可以添加按钮点击后的逻辑
end

return UIMain
