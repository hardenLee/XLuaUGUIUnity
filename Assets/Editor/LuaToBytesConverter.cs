using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;
using YooAsset.Editor;

public class LuaToBytesConverter : MonoBehaviour
{
    [MenuItem("Tools/Lua/Convert Lua to .bytes")]
    public static void ConvertLuaToBytes()
    {
        string luaFolderPath = Application.dataPath + "/Lua";
        if (!Directory.Exists(luaFolderPath))
        {
            Debug.LogError("Lua 文件夹不存在: " + luaFolderPath);
            return;
        }

        string[] luaFiles = Directory.GetFiles(luaFolderPath, "*.lua", SearchOption.AllDirectories);
        int convertedCount = 0;

        foreach (string filePath in luaFiles)
        {
            string bytesPath = filePath + ".bytes";

            // 直接覆盖，无需判断文件是否存在
            File.Copy(filePath, bytesPath, true);  // 第三个参数 true 表示覆盖

            Debug.Log($"已转换并覆盖：{filePath} → {bytesPath}");
            convertedCount++;
        }

        AssetDatabase.Refresh();
        Debug.Log($"Lua 转换完成，共转换并覆盖：{convertedCount} 个文件");
    }

}
