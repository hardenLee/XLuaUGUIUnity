using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        //ExplosionDamage(this.gameObject.transform.position, 10f);
        ExplosionDamage(GameObject.Find("Player").gameObject.transform.position, 10f);
        Debug.Log("playerGameObject.transform is :: " + GameObject.Find("Player").gameObject.transform.position);
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    void ExplosionDamage(Vector3 center, float radius)
    {
        int maxColliders = 10;
        Collider[] hitColliders = new Collider[maxColliders];
        int numColliders = Physics.OverlapSphereNonAlloc(center, radius, hitColliders);

        Debug.Log("numColliders = " + numColliders);
        for (int i = 0; i < numColliders; i++)
        {
            GameObject gameObject = hitColliders[i].gameObject;
            if ((gameObject.CompareTag("TestCube")))
            {
                Debug.Log("gameObject name is :: " + gameObject.name);
            }
        }
    }
}
