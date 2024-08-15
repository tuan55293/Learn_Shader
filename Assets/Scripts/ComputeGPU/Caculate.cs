using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Threading;
using UnityEngine;
using Debug = UnityEngine.Debug;

public class Caculate : MonoBehaviour
{
    public ComputeShader ComputeShaderTest;
    public float finaldata = 0;
    int count = 0;
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.O))
        {
            LoopWithoutGPU();
        }
        else if (Input.GetKeyDown(KeyCode.P))
        {
            LoopWithGPU();
        }
        else if (Input.GetKeyDown(KeyCode.M))
        {
            LoopWithMuitiThreadsCPU();
        }
    }

    public void LoopWithoutGPU()
    {
        Stopwatch stopwatch = new Stopwatch();
        stopwatch.Start();
        float fin = 0;
        for (int i = 0; i < 10000; i++)
        {
            float value = 0;
            for (int j = 0; j < 50000; j++)
            {
                value += 1;
            }
            fin += value;
        }
        Debug.Log(fin);
        stopwatch.Stop();
        Debug.LogWarning(stopwatch.ElapsedMilliseconds);
    }

    public void LoopWithGPU()
    {
        Stopwatch stopwatch = new Stopwatch();
        stopwatch.Start();
        Result[] data = new Result[10000];
        ComputeBuffer bufferdata = new ComputeBuffer(10000, System.Runtime.InteropServices.Marshal.SizeOf(typeof(Result)));
        bufferdata.SetData(data);
        ComputeShaderTest.SetBuffer(0, "Result", bufferdata);
        ComputeShaderTest.Dispatch(0, 10, 1, 1);
        bufferdata.GetData(data);

        float finaldata = 0;
        Debug.Log(data[0].value);
        for (int i = 0; i < 10000; i++)
        {
            finaldata += data[i].value;
        }
        Debug.Log(finaldata);
        bufferdata.Release();
        stopwatch.Stop();
        Debug.LogWarning(stopwatch.ElapsedMilliseconds);


    }

    public void LoopWithMuitiThreadsCPU()
    {
        Stopwatch stopwatch = new Stopwatch();
        stopwatch.Start();
        List<Thread> threads = new List<Thread>();

        for (int i = 0; i < 10; i++)
        {
            Thread thread = new Thread(new ThreadStart(Run));
            threads.Add(thread);
            thread.Start();
        }
        foreach (Thread thread in threads)
        {
            thread.Join();
        }
        Debug.Log(finaldata);
        stopwatch.Stop();
        Debug.LogWarning(stopwatch.ElapsedMilliseconds);
    }
    void Run()
    {
        float value = 0f;
        for (int j = 0; j < 500000; j++)
        {
            value += 1;
        }
        finaldata += value;
        //Debug.Log(value);
    }
    public struct Result
    {
        public float value;
    }
}