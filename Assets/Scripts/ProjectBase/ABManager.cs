using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.U2D;
using Object = UnityEngine.Object;

/// <summary>
/// 加载资源管理器 后期会修改yooAsset,addressable等资源加载方式
/// </summary>
public class ABManager : SingletonAutoMono<ABManager>
{
    public Object ResourcesLoad(string path, Type type)
    {
        Object obj = Resources.Load(path, type);
        if (obj != null && obj is GameObject)
        {
            return Instantiate(obj);
        }
        return obj;
    }
}
