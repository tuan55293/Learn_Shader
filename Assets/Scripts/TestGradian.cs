using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class TestGradian : MonoBehaviour
{
    public Color col;
    public Color col1;
    public Color col2;

    [Range(0f, 1f)]
    public float a;

    public Image Img;
    public Slider sl;
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {

    }

    public void ChangeCol()
    {
        col2.r = Mathf.Lerp(col.r, col1.r, sl.value);
        col2.g = Mathf.Lerp(col.g, col1.g, sl.value);
        col2.b = Mathf.Lerp(col.b, col1.b, sl.value);
        float h, s, v;
        Color.RGBToHSV(col2,out h,out s,out v);
        col2.a = 1;
        Img.color = new Color(h,s,v,1);
        //Img.color = col2;
    }

}
