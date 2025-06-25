using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class CsharpCallLuaList
{
    [XLua.CSharpCallLua]
    public static List<Type> csharpCallLuaList = new List<Type>();
}
