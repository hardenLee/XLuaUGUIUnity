using UnityEngine;
using UnityEditor;
using System.Collections;
using System.IO;

public class BuildAssetBundles
{
    [MenuItem("Assets/Build AssetBundles")]
    public static void BuildAllAssetBundles()
    {
        // 设置输出路径，通常是StreamingAssets文件夹  
        string assetBundleOutputPath =
            Path.Combine(
                Application.streamingAssetsPath,
                "AssetBundles");

        // 如果输出目录不存在，则创建它  
        if (!Directory.Exists(assetBundleOutputPath))
        {
            Directory.CreateDirectory(assetBundleOutputPath);
        }

        // 清理之前的AB包  
        if (Directory.Exists(assetBundleOutputPath))
        {
            FileUtil.DeleteFileOrDirectory(
                assetBundleOutputPath);
            AssetDatabase.Refresh();
            Debug.Log("成功清理之前的AB包");
        }

        // 使用BuildPipeline生成AB包  
        if(BuildPipeline.BuildAssetBundles(
            assetBundleOutputPath,
            BuildAssetBundleOptions.None,
            BuildTarget.StandaloneWindows))
        {
            Debug.Log("使用BuildPipeline生成AB包 成功");
        }
        else
        {
            Debug.Log("使用BuildPipeline生成AB包 失败");
        }

        // 刷新Unity编辑器，以显示新生成的AB包  
        AssetDatabase.Refresh();
    }
}