using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AppStart : MonoBehaviour
{
    private YooAssetsInit yooAssetsInit;
    public OperatingMode operatingMode = OperatingMode.EditorSimulateMode;
    
    private bool luaReady = false;
    
    private void Awake()
    {
        DontDestroyOnLoad(gameObject);
        yooAssetsInit = new YooAssetsInit();
    }

    private IEnumerator Start()
    {
        yield return yooAssetsInit.InitializeAndUpdate(operatingMode);
        
        LuaManager.Instance().Init();
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
