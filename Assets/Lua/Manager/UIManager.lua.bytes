local UIManager = {}

UIManager.panels = {} -- 存储所有面板的表
local PanelPaths = require("Config/UIPathConfig")
UIManager.panelRequirePaths = PanelPaths

-- 显示指定面板
function UIManager:LoadAndInstantiatePanel(panelName)
    local panel = self.panels[panelName]
    if not panel then
        local requirePath = self.panelRequirePaths[panelName]
        if not requirePath then
            error("No require path configured for panel: " .. panelName)
        end
        panel = require(requirePath)
        self.panels[panelName] = panel
    end

    -- 如果没有实例化 panelObj
    if not panel.panelObj then
        local prefabPath = self:GetPanelPrefabPath(panelName)
        local prefab = ABManager:LoadAssetSync(prefabPath, typeof(CS.UnityEngine.GameObject))
        if not prefab then
            error("Failed to load panel prefab: " .. prefabPath)
        end
        -- 一定要先赋值，再调用 Show
        panel.panelObj = prefab
        panel.panelObj.transform:SetParent(CanvasLow, false)
        print("UIManager:loadAssetSync", prefabPath)
    end

    return panel
end

function UIManager:ShowPanel(panelName)
    local panel = self:LoadAndInstantiatePanel(panelName)
    if panel and panel.Show then
        panel:Show() -- 此时 panelObj 已经不是 nil
    end
end

-- 关闭指定面板
function UIManager:HidePanel(panelName)
    local panel = self.panels[panelName]
    if not panel then
        print("UIManager: no such panel to hide:", panelName)
        return
    end

    -- 调用面板的Hide方法做一些状态和动画处理（非销毁GameObject）
    if panel.Hide then
        panel:Hide()
    end

    -- 销毁GameObject及相关资源
    if panel.panelObj then
        GameObject.Destroy(panel.panelObj)
        local prefabPath = self:GetPanelPrefabPath(panelName)
        ABManager:UnloadAsset(prefabPath)
        panel.panelObj = nil
        print("UIManager:UnloadAssetSync", prefabPath)
    end

    -- 移除缓存，下一次Show会重新加载实例化
    self.panels[panelName] = nil
end

-- 获取指定面板的预制体路径
function UIManager:GetPanelPrefabPath(panelName)
    return "Assets/Bundles/Prefabs/UI/" .. panelName .. ".prefab"
end

return UIManager
