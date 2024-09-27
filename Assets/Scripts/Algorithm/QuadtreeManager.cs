using System.Collections.Generic;
using UnityEngine;

public class QuadTreeManager : MonoBehaviour
{
    public int capacity = 4;
    private QuadTree quadTree;

    void Start()
    {
        // Thiết lập kích thước của quadtree root theo kích thước màn hình hiện tại
        Rect screenBoundary = new Rect(0, 0, Screen.width, Screen.height);
        quadTree = new QuadTree(screenBoundary, capacity);
    }

    void Update()
    {
        // Clear previous objects in the quadtree
        quadTree = new QuadTree(new Rect(0, 0, Screen.width, Screen.height), capacity);

        // Chèn GameObjects vào quadtree
        foreach (Transform obj in FindObjectsOfType<Transform>())
        {
            if (obj.CompareTag("Insertable"))
            {
                quadTree.Insert(obj);
            }
        }
    }

    void OnDrawGizmos()
    {
        if (quadTree != null)
        {
            // Sử dụng camera hiện tại để vẽ Gizmos trong không gian thế giới
            quadTree.DrawWorldGizmos(Camera.main);
        }
    }
}



public class QuadTree
{
    private Rect boundary;
    private int capacity;
    private List<Transform> objects;
    private bool divided = false;
    private QuadTree northwest;
    private QuadTree northeast;
    private QuadTree southwest;
    private QuadTree southeast;

    public QuadTree(Rect boundary, int capacity)
    {
        this.boundary = boundary;
        this.capacity = capacity;
        objects = new List<Transform>();
    }

    public void Subdivide()
    {
        if (!divided)
        {
            float x = boundary.x;
            float y = boundary.y;
            float w = boundary.width / 2;
            float h = boundary.height / 2;

            northwest = new QuadTree(new Rect(x, y + h, w, h), capacity);
            northeast = new QuadTree(new Rect(x + w, y + h, w, h), capacity);
            southwest = new QuadTree(new Rect(x, y, w, h), capacity);
            southeast = new QuadTree(new Rect(x + w, y, w, h), capacity);
            divided = true;
        }
    }

    public bool Insert(Transform obj)
    {
        if (!boundary.Contains(obj.position))
        {
            return false;
        }

        if (objects.Count < capacity)
        {
            objects.Add(obj);
            return true;
        }
        else
        {
            if (!divided)
            {
                Subdivide();
            }

            if (northwest.Insert(obj)) return true;
            if (northeast.Insert(obj)) return true;
            if (southwest.Insert(obj)) return true;
            if (southeast.Insert(obj)) return true;
        }

        return false;
    }

    public void DrawGizmos()
    {
        Gizmos.color = Color.red; // Chọn màu cho Gizmos
        Gizmos.DrawLine(new Vector3(boundary.xMin, boundary.yMin), new Vector3(boundary.xMax, boundary.yMin));
        Gizmos.DrawLine(new Vector3(boundary.xMax, boundary.yMin), new Vector3(boundary.xMax, boundary.yMax));
        Gizmos.DrawLine(new Vector3(boundary.xMax, boundary.yMax), new Vector3(boundary.xMin, boundary.yMax));
        Gizmos.DrawLine(new Vector3(boundary.xMin, boundary.yMax), new Vector3(boundary.xMin, boundary.yMin));

        if (divided)
        {
            northwest.DrawGizmos();
            northeast.DrawGizmos();
            southwest.DrawGizmos();
            southeast.DrawGizmos();
        }
    }

    // Hàm chuyển đổi từ tọa độ màn hình sang tọa độ thế giới
    public void DrawWorldGizmos(Camera camera)
    {
        Vector3 bottomLeft = camera.ScreenToWorldPoint(new Vector3(boundary.xMin, boundary.yMin, camera.nearClipPlane));
        Vector3 topRight = camera.ScreenToWorldPoint(new Vector3(boundary.xMax, boundary.yMax, camera.nearClipPlane));
        Vector3 topLeft = camera.ScreenToWorldPoint(new Vector3(boundary.xMin, boundary.yMax, camera.nearClipPlane));
        Vector3 bottomRight = camera.ScreenToWorldPoint(new Vector3(boundary.xMax, boundary.yMin, camera.nearClipPlane));

        Gizmos.color = Color.red;
        Gizmos.DrawLine(bottomLeft, bottomRight);
        Gizmos.DrawLine(bottomRight, topRight);
        Gizmos.DrawLine(topRight, topLeft);
        Gizmos.DrawLine(topLeft, bottomLeft);

        if (divided)
        {
            northwest.DrawWorldGizmos(camera);
            northeast.DrawWorldGizmos(camera);
            southwest.DrawWorldGizmos(camera);
            southeast.DrawWorldGizmos(camera);
        }
    }
}


