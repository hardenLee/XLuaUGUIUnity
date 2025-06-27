local UIManager = {}

UIManager.panels = {} -- 存储所有面板的表
local PanelPaths = require("Config/UIPathConfig")
UIManager.panelRequirePaths = PanelPaths


-- UIManager类的初始化方法
-- 这里可以用来加载初始的面板或设置默认值
function UIManager:Init()
    print("UIManager initialized.")
end

-- 显示指定面板
function UIManager:ShowPanel(panelName)
    local panel = UIManager.panels[panelName]
    if not panel then
        local requirePath = self.panelRequirePaths[panelName]
        if requirePath then
            panel = require(requirePath)
            self.panels[panelName] = panel
        end
    end
    if panel and panel.Show then
        panel:Show()
    else
        print("Panel " .. panelName .. " not found or does not have a Show method.")
    end
end

-- 隐藏指定面板
function UIManager:HidePanel(panelName)
    local panel = UIManager.panels[panelName]
    if panel and panel.Hide then
        panel:Hide() -- 调用面板的hide方法
        -- 销毁GameObject
        if panel.panelObj then
            GameObject.Destroy(panel.panelObj)
            panel.panelObj = nil
        end
        -- 可选：移除缓存（如果希望下次重新加载）
        self.panels[panelName] = nil
    else
        print("Panel " .. panelName .. " not found or does not have a Hide method.")
    end
end

return UIManager
