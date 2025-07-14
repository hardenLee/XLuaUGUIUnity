using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AppStart : MonoBehaviour
{
    private YooAssetsInit yooAssetsInit;
    private GlobalConfig globalConfig;
    private bool luaReady = false;
    
    private void Awake()
    {
        Init();
        DontDestroyOnLoad(gameObject);
        yooAssetsInit = new YooAssetsInit();
    }

    private void Init()
    {
        globalConfig = Resources.Load<GlobalConfig>("GlobalConfig");
    }

    private IEnumerator Start()
    {
        yield return yooAssetsInit.InitializeAndUpdate(globalConfig.operatingMode);
        
        LuaManager.Instance().Init(globalConfig);
        LuaManager.Instance().DoLuaFile("Main");

        luaReady = true;
        
        Debug.Log("[AppStart] 启动完成");
    }

    // Update is called once per frame
    void Update()
    {
        if (luaReady)
        {
            LuaManager.Instance().CallLuaUpdateEveryFrame();
        }
    }
}
