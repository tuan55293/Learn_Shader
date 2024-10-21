using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Animations.Rigging;
using UnityEngine.Serialization;
using UnityEngine.UI;   

public class ZombileController : MonoBehaviour
{
    public Transform Head;
    public float RadiusCheck;
    public CubicBezierCurve Curve;
    private int indexPoint = 0;
    public float Speed = 5;
    private Collider[] hit;
    private List<Transform> hitInRange = new List<Transform>();
    private Transform target;
    public LayerMask layerMask;
    public MultiAimConstraint MultiAimHead;
    public RigBuilder RigBuilders;
    public Animator Animators;
    public Transform HeadDir;
    private bool isDone;

    [Space(5)] 
    [Header("UI Elements")]
    public Image ProcessBar;

    void Start()
    {
        if (Curve != null)
        {
            Curve.SetPoints();
        }
        ProcessBar.fillAmount = 0;
    }

    void Update()
    {
        if (isDone)
        {
            MultiAimHead.weight = Mathf.Lerp(MultiAimHead.weight, 0, 0.1f);
            return;
        }

        if (indexPoint > Curve.Points.Count - 1)
        {
            isDone = true;
            var data = MultiAimHead.data.sourceObjects;
            data.SetTransform(0, null);
            MultiAimHead.data.sourceObjects = data;
            Animators.enabled = false;
            RigBuilders.Build();
            Animators.enabled = true;
            Animators.Play("idle");
        }
        else
        {
            #region Check các vật thể trong bán kính cho trước

            if (Vector3.Distance(transform.position, Curve.Points[indexPoint]) > 0.01f)
            {
                transform.position =
                    Vector3.MoveTowards(transform.position, Curve.Points[indexPoint], Time.deltaTime * Speed);
                transform.LookAt(Curve.Points[indexPoint]);
            }
            else
            {
                //transform.position = Curve.Points[indexPoint];
                ProcessBar.fillAmount = (float)indexPoint / (float)Curve.Points.Count;
                transform.LookAt(Curve.Points[indexPoint]);
                indexPoint++;
            }

            hitInRange.Clear();
            hit = Physics.OverlapSphere(Head.position, RadiusCheck, layerMask);

            #endregion
            
            HeadAim();
        }
    }

    #region Xoay đầu về hướng vật thể

        public void HeadAim()
        {
            if (hit.Length > 0)
            {
                for (int i = 0; i < hit.Length; i++)
                {
                    // Tìm các vật thể nằm trong vùng nhìn 60 độ phía trước so với zombie.
                    Vector3 directionToObject = (hit[i].transform.position - HeadDir.position).normalized;
                    float angleToObject = Vector3.Angle(HeadDir.forward, directionToObject);
                    float dotProduct = Vector3.Dot(HeadDir.forward, directionToObject);
                    if (angleToObject <= 120 / 2f && dotProduct > 0)
                    {
                        hitInRange.Add(hit[i].transform);
                    }
                }
    
                if (hitInRange.Count > 0)
                {
                    // Chọn vật thể gần nhất trong tập hợp các vật thể nằm trong vùng nhìn.
                    Transform min = hitInRange[0].transform;
                    for (int i = 0; i < hitInRange.Count; i++)
                    {
                        if (Vector3.Distance(Head.position, hitInRange[i].transform.position) <
                            Vector3.Distance(Head.position, min.position))
                        {
                            min = hitInRange[i].transform;
                        }
                    }
    
                    if (target != min)
                    {
                        Animators.enabled = false;
                        target = min;
                        var data = MultiAimHead.data.sourceObjects;
                        data.SetTransform(0, target);
                        MultiAimHead.data.sourceObjects = data;
                        MultiAimHead.weight = 0;
                        Animators.enabled = false;
                        RigBuilders.Build();
                        Animators.enabled = true;
                    }
                }
                else
                {
                    MultiAimHead.weight = Mathf.Lerp(MultiAimHead.weight, 0, 0.1f);
                    return;
                }
    
                if (target)
                {
                    MultiAimHead.weight = Mathf.Lerp(MultiAimHead.weight, 1, Time.deltaTime * 10);
                    Debug.DrawLine(Head.position, target.position, Color.cyan);
                }
            }
            else
            {
                var data = MultiAimHead.data.sourceObjects;
                data.SetTransform(0, null);
                MultiAimHead.data.sourceObjects = data;
                MultiAimHead.weight = Mathf.Lerp(MultiAimHead.weight, 0, 0.1f);
                Animators.enabled = false;
                RigBuilders.Build();
                Animators.enabled = true;
            }
        }

    #endregion

}