using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

public class Paralax : MonoBehaviour
{
    public GameObject cam;
    public float effect,le;
    float starpos;
    void Start()
    {
        starpos = transform.position.x;
        le = GetComponent<SpriteRenderer>().bounds.size.x;
    }

    // Update is called once per frame
    void Update()
    {
        float x = cam.transform.position.x * effect;

        float temp = cam.transform.position.x * (1-effect);
        transform.position = new Vector3(starpos + x, transform.position.y, 0);
        if (temp > starpos + le)
        {
            starpos += le * 2;
        }
        else if (temp < starpos - le)
        {
            starpos -= le * 2;
        }
    }
}
