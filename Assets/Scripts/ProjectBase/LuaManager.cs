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
        luaEnv.AddLoader(MyCustomLoader);
        //luaEnv.AddLoader(MyCustomLoaderFormAB);

        LuaCallPhysics();
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

    private byte[] MyCustomLoader(ref string filepath)
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

    // //再写一个Load 用于从AB包加载Lua文件
    // private byte[] MyCustomLoaderFormAB(ref string filepath)
    // {
    //     //改为我们的AB包管理器加载
    //     TextAsset file2 = ABManager.Instance().LoadRes<TextAsset>("lua", filepath + ".lua");
    //     if (file2 != null)
    //         return file2.bytes;
    //     else
    //         Debug.Log("MyCustomLoaderFormAB重定向失败");
    //     return null;
    // }

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
    public void CallLuaUpdateEveryFrame() ///-->【调用Update方法】<--
    {
        // 获取Lua中的更新函数  
        luaUpdateFunction = luaEnv.Global.GetInPath<LuaFunction>("CsherpCallUpdate");
        //if (luaUpdateFunction != null)
        // 调用Lua更新函数（注意：这里没有传递参数，如果你的函数需要参数，请在这里传递）  
        luaUpdateFunction.Call();
        //else
        //    Debug.Log("luaUpdateFunction is null");


        //// 获取 LuaUpdate 对象  
        //LuaTable luaUpdateTable = luaEnv.Global.Get<LuaTable>("LuaUpdate");
        //if (luaUpdateTable != null && luaUpdateTable.Get<LuaFunction>("Update") != null)
        //{
        //    // 调用 LuaUpdate 对象的 Update 方法  
        //    luaUpdateTable.Get<LuaFunction>("Update").Call();
        //    //luaUpdateTable.Get<LuaFunction>("CsherpCallUpdate").Call();
        //}
        //else
        //{
        //    Debug.Log("LuaUpdate table or Update function is null");
        //}
    }

    public void LuaCallPhysics()
    {
        //// 创建一个PhysicsHelper实例  
        //LuaCallPhysics physicsHelper = new GameObject("LuaCallPhysics").AddComponent<LuaCallPhysics>();

        //// 将PhysicsHelper实例绑定到Lua全局变量中  
        //luaEnv.Global["LuaCallPhysics"] = LuaCallPhysics;

        // 注册PhysicsWrapper到Lua全局环境  
        luaEnv.Global["LuaCallPhysics"] = typeof(LuaCallPhysics);
    }
}
