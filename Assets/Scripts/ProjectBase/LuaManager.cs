using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using XLua;

/// <summary>
/// Lua管理器
/// </summary>
public class LuaManager : BaseManager<LuaManager>
{
    private LuaEnv luaEnv; // 确保这个 LuaEnv 是被正确初始化的  
    private LuaTable luaUpdateTable; // 用于存储 LuaUpdate 对象 ///-->【调用Update方法】<--

    public void Init()
    {
        //唯一的解析器
        luaEnv = new LuaEnv();
        //添加重定向委托函数
        //luaEnv.AddLoader(CustomLoader);
        luaEnv.AddLoader(CustomLoaderFormAB);
    }

    //Lua总表
    //用于之后 lua访问C#时 使用 通过总表获取lua中各种内容
    public LuaTable Global
    {
        get
        {
            return luaEnv.Global;
        }
    }

    private byte[] CustomLoader(ref string filepath)
    {
        //测试传入的参数是什么
        Debug.Log("LuaManager" + filepath);
        //决定Lua文件所在路径
        string path = Application.dataPath + "/Lua/" + filepath + ".lua";
        //C#自带的文件读取类
        if (File.Exists(path))
        {
            return File.ReadAllBytes(path);
        }
        else
            Debug.Log("MyCustomLoader重定向失败");

        return null;
    }

    //再写一个Load 用于从AB包加载Lua文件
    private byte[] CustomLoaderFormAB(ref string filepath)
    {
        string address = $"Assets/Lua/{filepath}.lua.bytes";
        Debug.Log($"Trying to load Lua asset at: {address}");

        Object obj = ABManager.Instance().LoadAssetSync(address, typeof(TextAsset));
        TextAsset luaAsset = obj as TextAsset;

        if (luaAsset != null)
        {
            Debug.Log($"Loaded Lua asset successfully: {address}");
            return luaAsset.bytes;
        }
        else
        {
            Debug.LogError($"Failed to load Lua asset from AB: {address}");
            return null;
        }
    }

    /// <summary>
    /// 执行lua文件
    /// </summary>
    /// <param name="fileName"></param>
    /// <param name="formWhere"></param>
    public void DoLuaFile(string fileName, string formWhere = null)
    {
        string str = string.Format("require('{0}')", fileName);
        luaEnv.DoString(str);
    }

    //执行Lua脚本
    public void DoString(string luaScript, string fromWhere = null)
    {
        luaEnv.DoString(luaScript, fromWhere);
    }

    //释放垃圾
    public void Tick()
    {
        luaEnv.Tick();
    }

    //销毁
    public void Dispose()
    {
        luaEnv.Tick();
        luaEnv.Dispose();
    }

    private LuaFunction luaUpdateFunction;
    public void CallLuaUpdateEveryFrame()
    {
        // 获取Lua中的更新函数  
        luaUpdateFunction = luaEnv.Global.GetInPath<LuaFunction>("CsherpCallUpdate");
        luaUpdateFunction.Call();
    }

}
