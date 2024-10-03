using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotateTrans : MonoBehaviour
{
    public Transform target;
    public float angle = 1;
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {

        transform.RotateAround(target.position, Vector3.up, angle*5*Time.deltaTime*20 );
    }
}
