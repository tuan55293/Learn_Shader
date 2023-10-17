using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMove : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKey(KeyCode.A))
        {
            transform.position -= new Vector3(Time.deltaTime * 5,0);
        }
        else if(Input.GetKey(KeyCode.D)) 
        {
            transform.position += new Vector3(Time.deltaTime * 5, 0);
        }
    }
}
