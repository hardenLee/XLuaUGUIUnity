﻿using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.SceneManagement;
using XLua;
using YooAsset;

/// <summary>
/// 加载资源管理器，统一封装 YooAsset（可拓展 Addressables）
/// </summary>
public class ABManager : SingletonAutoMono<ABManager>
{
    /// <summary> 默认资源包访问器，每次从 YooAssets 获取，确保不为 null </summary>
    private ResourcePackage package => YooAssets.GetPackage("DefaultPackage");

    #region ========== 基础资源加载 ==========

    /// <summary> 同步加载资源对象 </summary>
    public AssetHandle LoadAssetSync<T>(string location) where T : UnityEngine.Object
    {
        return package.LoadAssetSync<T>(location);
    }
    
    /// <summary> 异步加载资源对象并且实例化 </summary>
    public UnityEngine.Object LoadAssetSync(string location, System.Type type)
    {
        var handle = package.LoadAssetSync(location, type);
        var asset = handle.AssetObject;

        if (asset == null)
        {
            Debug.LogError($"LoadAssetSync failed: {location} returned null.");
            return null;
        }

        // 如果是 GameObject，则自动实例化
        if (asset is GameObject prefab)
        {
            return GameObject.Instantiate(prefab);
        }

        // 否则直接返回原资源（比如 Texture、AudioClip、TextAsset 等）
        return asset;
    }

    /// <summary> 异步加载资源对象，返回 Task 方式 </summary>
    public async Task<GameObject> LoadAndInstantiateAsync(string location)
    {
        var handle = package.LoadAssetAsync<GameObject>(location);
        await handle.Task;

        var prefab = handle.AssetObject as GameObject;
        if (prefab == null)
        {
            Debug.LogError($"LoadAndInstantiateAsync failed: {location} is not a GameObject.");
            return null;
        }

        return GameObject.Instantiate(prefab);
    }

    #endregion

    #region ========== 预制体加载并实例化 ==========

    /// <summary> 异步加载并实例化预制体 </summary>
    public async Task<GameObject> LoadPrefabAsync(string location)
    {
        var handle = package.LoadAssetAsync<GameObject>(location);
        await handle.Task;
        return handle.InstantiateSync();
    }

    #endregion

    #region ========== 子资源加载（如图集中的 Sprite） ==========

    /// <summary>
    /// 异步加载子资源对象（如图集中的 Sprite）
    /// </summary>
    public async Task<T> LoadSubAssetAsync<T>(string location, string subName) where T : UnityEngine.Object
    {
        var handle = package.LoadSubAssetsAsync<T>(location);
        await handle.Task;
        return handle.GetSubAssetObject<T>(subName);
    }

    #endregion

    #region ========== 加载资源包内所有资源对象 ==========

    /// <summary>
    /// 异步加载某个资源包内所有资源（如多个配置表）
    /// </summary>
    public async Task<List<T>> LoadAllAssetsAsync<T>(string location) where T : UnityEngine.Object
    {
        var handle = package.LoadAllAssetsAsync<T>(location);
        await handle.Task;

        var results = new List<T>();
        foreach (var obj in handle.AllAssetObjects)
        {
            results.Add(obj as T);
        }

        return results;
    }

    #endregion

    #region ========== 场景异步加载 ==========

    /// <summary>
    /// 异步加载场景（默认 LoadSceneMode.Single）
    /// </summary>
    public async Task LoadSceneAsync(string location, LoadSceneMode mode = LoadSceneMode.Single)
    {
        var handle = package.LoadSceneAsync(location, mode);
        await handle.Task;
        if (handle.Status != EOperationStatus.Succeed)
            Debug.LogError($"场景加载失败: {location}");
    }

    #endregion

    #region ========== 原生文件加载（如 .bytes/.bnk） ==========

    /// <summary>
    /// 异步加载原生文件（RawFile）
    /// </summary>
    public async Task<(string text, byte[] data)> LoadRawFileAsync(string location)
    {
        var handle = package.LoadRawFileAsync(location);
        await handle.Task;

        string text = handle.GetRawFileText();
        byte[] data = handle.GetRawFileData();
        return (text, data);
    }

    #endregion

    #region ========== 获取资源信息 ==========

    /// <summary> 根据标签获取资源信息列表 </summary>
    public AssetInfo[] GetAssetInfosByTag(string tag)
    {
        return package.GetAssetInfos(tag);
    }

    /// <summary> 获取所有资源信息 </summary>
    public AssetInfo[] GetAllAssetInfos()
    {
        return package.GetAllAssetInfos();
    }

    #endregion

    #region ========== Unity Resources 加载（兼容处理） ==========

    public UnityEngine.Object ResourcesLoad(string path, Type type)
    {
        UnityEngine.Object obj = Resources.Load(path, type);
        if (obj != null && obj is GameObject)
        {
            return Instantiate(obj);
        }

        return obj;
    }

    #endregion
}