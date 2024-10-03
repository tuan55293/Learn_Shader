using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ReplacementShaderr : MonoBehaviour
{
    // Start is called before the first frame update
    public Shader S;
    private void Start()
    {
        Debug.Log("Start");
    }

    // Update is called once per frame
    private void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            Camera.main.SetReplacementShader(S, "RenderQueue");
        }
        else if(Input.GetMouseButtonDown(1))
        {
            Camera.main.ResetReplacementShader();
        }
    }
}
