-- 如果我们需要对“道具格子面板”进行面向对象的优化,那我们需要解决哪些问题？
-- 0. 继承Object
Object:subClass("ItemGrid")
--- "成员变量"
ItemGrid.obj = nil
ItemGrid.imgIcon = nil
ItemGrid.Text = nil
--- "成员方法":

-- 1. 实例化 “道具格子面板”对象（主要就是优化BagPanel:ChangeType里面的逻辑）
--- father >> 父对象,相对于BagPanel.Content
--- posX、posY >> BagPanel:ChangeType里面用于计算“格子”位置的参数
function ItemGrid:Init(father, posX, posY)
    self.obj = ABMgr:LoadRes("ui", "ItemGrid", typeof(GameObject))

    self.obj.transform:SetParent(father, false)

    self.obj.transform.localPosition = Vector3(posX, posY, 0)

    self.imgIcon = self.obj.transform:Find("imgIcon"):GetComponent(typeof(Image))
    self.Text = self.obj.transform:Find("Text (Legacy)"):GetComponent(typeof(Text))
end

-- 2. 初始化 “道具格子”信息
--- data >> 道具的信息(道具ID&数量)
function ItemGrid:InitData(data)
    -- 设置图标
    -- 通过PlayerData中的道具ID,获取 图标信息
    local itemdata = ItemData[data.id]
    -- 根据data加载图集，再加载其图标
    local strs = string.split(itemdata.icon, "_")
    local spriteAtlas = ABMgr:LoadRes("ui", strs[1], typeof(SpriteAtlas))
    self.imgIcon.sprite = spriteAtlas:GetSprite(strs[2])
    -- 设置文本
    self.Text.text = data.num
end

-- 3. 添加一些独属于“道具格子对象”的逻辑（悬停监听）
--- 删除 “格子”对象
function ItemGrid:Destroy()
    GameObject.Destroy(self.obj)
    self.obj = nil
end