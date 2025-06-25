using System.Collections;
using System.Collections.Generic;
using UnityEditor.UIElements;
using UnityEngine;

public class Main : MonoBehaviour
{
    public Canvas canvas;
    // Start is called before the first frame update
    void Start()
    {
        LuaMgr.GetInstance().Init();
        LuaMgr.GetInstance().DoLuaFile("Main");
        canvas = GameObject.Find("Canvas").GetComponent<Canvas>();
        Camera worldCamera = canvas.worldCamera;
    }

    // Update is called once per frame
    void Update()
    {
        //LuaMgr.GetInstance().DoLuaFile("LuaUpdate");
        LuaMgr.GetInstance().CallLuaUpdateEveryFrame();

        //if (Input.GetMouseButtonDown(0)) 
        //{
        //    Vector3 mousePos = Input.mousePosition;
        //    Vector2 mouseInUI = MouseInUI(canvas, mousePos);
        //}

    }

    /// <summary>
    /// ��ȡ�������ϷUI�ռ����е�����
    /// </summary>
    /// <param name="canvas"></param>
    /// <param name="mouseScreenPos"></param>
    /// <returns></returns>
    public Vector2 MouseInUI(Canvas canvas, Vector3 mouseScreenPos)
    {
        // ת��������Ļ���굽Canvas�ı�������  
        Vector2 mouseUIPos;
        if (RectTransformUtility.ScreenPointToLocalPointInRectangle(
                canvas.transform as RectTransform,
                mouseScreenPos,
                canvas.worldCamera, // ����Canvas��Render Camera���������Ļ�ռ�Canvas��Ϊnull  
                out mouseUIPos))
        {
            // ���ת���ɹ���mouseUIPos�����������Canvas���������µ�λ��  
            Debug.Log("Mouse Position in UI: " + mouseUIPos);
            return mouseUIPos;
        }
        else
        {
            // ���ת��ʧ�ܣ���������Ϊ��겻��Canvas�ľ���������  
            Debug.Log("Mouse is not over the Canvas");
            return Vector2.zero;
        }
    }
}


