using System;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class LoopScrollRectTest : MonoBehaviour
{
    public LoopScrollRectEx scrollList;
    public GameObject itemPrefab;

    void Start()
    {
        // 伪造 100 条测试数据
        var testData = new List<string>();
        for (int i = 1; i <= 100; i++)
        {
            testData.Add("index: " + i);
        }

        // 初始化组件（用 C# lambda 实现 getItemData 和 onItemUpdate）
        scrollList.itemPrefab = itemPrefab;
        scrollList.Init(
            (index) =>
            {
                if (index >= 0 && index < testData.Count)
                    return testData[index];
                return null;
            },
            (go, index, data) =>
            {
                var text = go.transform.Find("Text").GetComponent<TextMeshProUGUI>();
                text.text = data.ToString();
            }
        );
    }
}

