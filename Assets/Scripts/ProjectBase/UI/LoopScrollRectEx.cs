// LoopScrollRectEx.cs
// 简易版 UGUI 无限滚动列表组件（支持与 XLua 数据驱动）
// 实现了基于 itemPrefab 的对象池复用、自动定位、动态更新等功能

using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class LoopScrollRectEx : MonoBehaviour
{
    // 🔹 滚动项预制体（Item UI 必须挂 RectTransform）
    public GameObject itemPrefab;

    // 🔹 ScrollView 中的 Content（动态调整 size + 控制 item 挂载位置）
    [HideInInspector]
    public RectTransform content;

    // 🔹 滚动组件（用于监听滚动事件）
    [HideInInspector]
    public ScrollRect scrollRect;

    // 🔹 每个 item 间距
    public int spacing = 10;

    // 🔹 数据总量（由 Init 时动态获取）
    private int totalCount;

    // 🔹 获取每一项数据的方法（从 Lua/C# 传入）
    private Func<int, object> getItemData;

    // 🔹 每当 item 需要更新显示时调用（由外部实现，如设置文字、图片等）
    private Action<GameObject, int, object> onItemUpdate;

    // 🔹 对象池：循环使用 item 实例，避免反复 Instantiate/Destroy
    private List<GameObject> itemPool = new List<GameObject>();

    void Awake()
    {
        scrollRect = transform.Find("Scroll View").GetComponent<ScrollRect>();
        content = scrollRect.content;


        // 🔸 绑定滚动监听事件
        scrollRect.onValueChanged.AddListener(OnScroll);

        // 🔸 禁用模板预制体（避免启动时显示）
        itemPrefab.SetActive(false);
    }

    /// <summary>
    /// 初始化滚动列表
    /// </summary>
    /// <param name="dataGetter">获取数据的函数（index => object）</param>
    /// <param name="itemUpdater">更新 item 显示内容的函数（item, index, data）</param>
    public void Init(Func<int, object> dataGetter, Action<GameObject, int, object> itemUpdater)
    {
        getItemData = dataGetter;
        onItemUpdate = itemUpdater;

        // 计算数据总量（直到返回 null 为止）
        totalCount = 0;
        while (getItemData(totalCount) != null)
        {
            totalCount++;
        }

        InitLoopPool();         // 初始化对象池
        RefreshVisible();   // 初始化可视区域 item 显示
    }

    /// <summary>
    /// 初始化对象池，根据视图区域的高度动态创建一定数量的 item 复用
    /// </summary>
    void InitLoopPool()
    {
        float itemHeight = GetItemHeight(itemPrefab);

        // 可视区域显示的 item 数量 +2（缓冲）
        int viewCount = Mathf.CeilToInt(scrollRect.viewport.rect.height / (itemHeight + spacing)) + 2;

        for (int i = 0; i < viewCount; i++)
        {
            // 生成 item，挂载到 content 下
            GameObject go = Instantiate(itemPrefab, content);
            go.SetActive(true);

            // 初始位置排列
            go.GetComponent<RectTransform>().anchoredPosition = new Vector2(0, -i * (itemHeight + spacing));
            itemPool.Add(go);
        }

        // 设置 content 的总高度，确保滚动条可滚动
        content.sizeDelta = new Vector2(content.sizeDelta.x, totalCount * (itemHeight + spacing));
    }

    /// <summary>
    /// 获取 itemPrefab 的实际高度（读取 RectTransform）
    /// </summary>
    float GetItemHeight(GameObject prefab)
    {
        var rt = prefab.GetComponent<RectTransform>();
        if (rt != null)
            return rt.rect.height;

        Debug.LogWarning("Item prefab has no RectTransform or height is zero.");
        return 100; // fallback 默认高度
    }

    /// <summary>
    /// 当滚动时刷新可见区域（替换内容 + 复用对象）
    /// </summary>
    void OnScroll(Vector2 pos)
    {
        RefreshVisible();
    }

    /// <summary>
    /// 更新所有 itemPool 中的 item，判断其是否显示 + 更新数据 + 设置位置
    /// </summary>
    void RefreshVisible()
    {
        if (itemPool.Count == 0) return;

        float itemHeight = GetItemHeight(itemPool[0]);

        // 当前滚动位置，决定起始 index
        float y = content.anchoredPosition.y;
        int startIndex = Mathf.FloorToInt(y / (itemHeight + spacing));

        for (int i = 0; i < itemPool.Count; i++)
        {
            int dataIndex = startIndex + i;
            GameObject go = itemPool[i];

            if (dataIndex >= 0 && dataIndex < totalCount)
            {
                go.SetActive(true);

                // 更新位置（上 -> 下）
                RectTransform rt = go.GetComponent<RectTransform>();
                rt.anchoredPosition = new Vector2(0, -dataIndex * (itemHeight + spacing));

                // 获取数据 + 更新显示
                var data = getItemData(dataIndex);
                onItemUpdate?.Invoke(go, dataIndex, data);
            }
            else
            {
                // 超出数据范围的隐藏掉
                go.SetActive(false);
            }
        }
    }
}