using UnityEngine;
using UnityEditor;
using System.Collections;
using System.IO;

public class BuildAssetBundles
{
    [MenuItem("Assets/Build AssetBundles")]
    public static void BuildAllAssetBundles()
    {
        // �������·����ͨ����StreamingAssets�ļ���  
        string assetBundleOutputPath =
            Path.Combine(
                Application.streamingAssetsPath,
                "AssetBundles");

        // ������Ŀ¼�����ڣ��򴴽���  
        if (!Directory.Exists(assetBundleOutputPath))
        {
            Directory.CreateDirectory(assetBundleOutputPath);
        }

        // ����֮ǰ��AB��  
        if (Directory.Exists(assetBundleOutputPath))
        {
            FileUtil.DeleteFileOrDirectory(
                assetBundleOutputPath);
            AssetDatabase.Refresh();
            Debug.Log("�ɹ�����֮ǰ��AB��");
        }

        // ʹ��BuildPipeline����AB��  
        if(BuildPipeline.BuildAssetBundles(
            assetBundleOutputPath,
            BuildAssetBundleOptions.None,
            BuildTarget.StandaloneWindows))
        {
            Debug.Log("ʹ��BuildPipeline����AB�� �ɹ�");
        }
        else
        {
            Debug.Log("ʹ��BuildPipeline����AB�� ʧ��");
        }

        // ˢ��Unity�༭��������ʾ�����ɵ�AB��  
        AssetDatabase.Refresh();
    }
}