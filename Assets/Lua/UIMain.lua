local UIMain = {}
local UIManager = require("UIManager")
UIManager:RegisterPanel("UIMain", UIMain)

MainPanel.panelObj = nil -- 关联的面板对象
MainPanel.btnRole = nil
MainPanel.btnCharacter = nil


function UIMain:Show()
    print("lyk UIMain.Show() called")
    self.panelObj = ABMgr:ResourcesLoad("Prefabs/UI/UIMain", typeof(GameObject)) -- 这里的`self.`代指“调用者”(谁调用这个方法，self就代表谁)
    self.panelObj.transform:SetParent(Canvas, false)
end

function UIMain:Hide()
    print("lyk UIMain.Hide() called")
end

return UIMain
