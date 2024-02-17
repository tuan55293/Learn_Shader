using System;
using System.Collections;
using System.Collections.Generic;
using Unity.Mathematics;
using Unity.VisualScripting;
using UnityEngine;

public class PlayerMove : MonoBehaviour
{
    float angle;
    float anglerad;
    float cosanglerad;
    void Start()
    {
        anglerad = 90 * Mathf.Deg2Rad;
        cosanglerad = Mathf.Round(MathF.Cos(anglerad *10000f))*0.0001f;
        Debug.Log(cosanglerad);
    }

    // Update is called once per frame
    void Update()
    {

    }
}
