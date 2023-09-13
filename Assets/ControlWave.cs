using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UIElements;

public class ControlWave : MonoBehaviour
{
    public Material waveMaterial;
    public Transform Sea;
    public List<Transform> wave;
    public List<Vector4> copywave;
    void Start()
    {
        for (int i = 0; i < wave.Count; i++)
        {
            Vector4 a = new Vector4(wave[i].position.x, 0, wave[i].position.z, 0);
            copywave.Add(a);
        }

    }

    void Update()
    {
        waveMaterial.SetInt("_numberOfArray", wave.Count);
        copywave.Clear();
        for (int i = 0; i < wave.Count; i++)
        {
            //Chia  tỉ lệ theo scale đoạn này đang bị lỗi nếu mặt biển không nằm tại 0,0,0 của thế giới !
            Vector4 a = new Vector4(wave[i].position.x / Sea.transform.localScale.x - Sea.transform.position.x, 0, wave[i].position.z / Sea.transform.localScale.z - Sea.transform.position.z, 0);
            copywave.Add(a);
        }

        // Truyền mảng vector vào trong HLSL
        waveMaterial.SetVectorArray("myCenter", copywave);

    }
}
