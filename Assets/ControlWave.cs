using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ControlWave : MonoBehaviour
{
    public Material waveMaterial;
    public Transform wave;
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        waveMaterial.SetVector("_PointCenter2",new Vector4(transform.position.x / wave.transform.localScale.x - wave.transform.position.x,0,transform.position.z/ wave.transform.localScale.z - wave.transform.position.z,0));
    }
}
