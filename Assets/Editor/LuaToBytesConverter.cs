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

            if (File.Exists(bytesPath))
            {
                Debug.Log($"已存在：{bytesPath}，跳过");
                continue;
            }

            File.Copy(filePath, bytesPath);
            Debug.Log($"已转换：{filePath} → {bytesPath}");
            convertedCount++;
        }

        AssetDatabase.Refresh();
        Debug.Log($"Lua 转换完成，共转换：{convertedCount} 个文件");
    }
}
