local UIManager = {}

UIManager.panels = {} -- 存储所有面板的表

-- UIManager类的初始化方法
-- 这里可以用来加载初始的面板或设置默认值
function UIManager:Init()
    print("UIManager initialized.")
    -- 可以在这里注册一些默认的面板
    -- UIManager:RegisterPanel("MainPanel", MainPanel) -- 假设MainPanel是一个面板对象
    -- UIManager:RegisterPanel("BagPanel", BagPanel)   -- 假设BagPanel是另一个面板对象
    -- 其他面板可以根据需要添加
end

-- 注册面板
-- 这里的注册面板函数可以用来将面板添加到UIManager中
function UIManager:RegisterPanel(panelName, panel)
    UIManager.panels[panelName] = panel
end

-- 显示指定面板
function UIManager:ShowPanel(panelName)
    local panel = UIManager.panels[panelName]
    if panel and panel.Show then
        panel:Show() -- 调用面板的show方法
    else
        print("Panel " .. panelName .. " not found or does not have a Show method.")
    end
end

-- 隐藏指定面板
function UIManager:HidePanel(panelName)
    local panel = UIManager.panels[panelName]
    if panel and panel.Hide then
        panel:Hide() -- 调用面板的hide方法
    else
        print("Panel " .. panelName .. " not found or does not have a Hide method.")
    end
end

return UIManager
