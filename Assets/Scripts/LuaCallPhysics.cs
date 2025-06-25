using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class LuaCallPhysics
{
    [XLua.CSharpCallLua]
    static LuaCallPhysics()
    {

    }

    [XLua.CSharpCallLua]
    public static Collider[] OverlapSphere(Vector3 center, float radius)
    {
        Collider[] colliders = Physics.OverlapSphere(center, radius);
        Collider[] buffer = new Collider[colliders.Length + 2];
        for (int i = 0; i < colliders.Length; ++i)
        {
            buffer[i + 1] = colliders[i]; // 新数组的索引是i+1，原始数组的索引是i
        }
        buffer[colliders.Length + 1] = null;
        return buffer;
    }
}
