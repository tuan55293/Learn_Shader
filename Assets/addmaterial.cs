using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class addmaterial : MonoBehaviour
{
    public Material mate;
    void Start()
    {
        Material m = new Material(mate);

        Renderer r = gameObject.GetComponent<Renderer>();
        r.material = m;
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
