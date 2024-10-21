using System;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.Serialization;

public class CubicBezierCurve : MonoBehaviour
{
    public Transform point1;
    public Transform point2;
    public Transform point3;
    public Transform point4;
    
    public int segmentCount = 20;

    [HideInInspector]
    public List<Vector3> Points;

    public void SetPoints()
    {
        for (int i = 1; i <= segmentCount; i++)
        {
            float t = i / (float)segmentCount;
            Vector3 currentPoint = CalculateCubicBezierPoint(t, point1.position, point2.position, point3.position, point4.position);
            Points.Add(currentPoint);
        }
    }

    private void OnDrawGizmos()
    {
        if (point1 != null && point2 != null && point3 != null && point4 != null)
        {
            Gizmos.color = Color.red;
            Gizmos.DrawLine(point1.position, point2.position);
            Gizmos.DrawLine(point3.position, point4.position);
            
            Gizmos.color = Color.white;
            Vector3 previousPoint = point1.position;

            for (int i = 1; i <= segmentCount; i++)
            {
                float t = i / (float)segmentCount;
                Vector3 currentPoint = CalculateCubicBezierPoint(t, point1.position, point2.position, point3.position, point4.position);
                Gizmos.DrawLine(previousPoint, currentPoint);
                previousPoint = currentPoint;
            }
        }
    }
    
    private Vector3 CalculateCubicBezierPoint(float t, Vector3 p1, Vector3 p2, Vector3 p3, Vector3 p4)
    {
        float u = 1 - t;
        float tt = t * t;
        float uu = u * u;
        float uuu = uu * u;
        float ttt = tt * t;

        Vector3 point = uuu * p1;
        point += 3 * uu * t * p2;
        point += 3 * u * tt * p3;
        point += ttt * p4;       

        return point;
    }
}