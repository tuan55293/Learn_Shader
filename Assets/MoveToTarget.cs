using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveToTarget : MonoBehaviour
{
    public GameObject target;
    public Vector3 dir;
    

    public float row;
    public float col;
    void Start()
    {
        dir = transform.position - Vector3.zero;
        dir /= col;

        for (int i = 1; i < col+1;i++)
        {
            Instantiate(target, Vector3.zero + dir * i, Quaternion.identity);
        }

    }
    void Update()
    {
        //if (Vector3.Distance(transform.position, target.transform.position) < 0.5f) return;
        //transform.position += dir * Time.deltaTime;
    }
}
