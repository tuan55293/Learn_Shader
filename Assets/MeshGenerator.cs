using System.Collections.Generic;
using UnityEngine;

public class MeshGenerator : MonoBehaviour
{
    public int widthSegments = 10; // Số đoạn chia theo chiều ngang
    public int depthSegments = 10; // Số đoạn chia theo chiều sâu
    public float width = 10f; // Kích thước theo chiều ngang
    public float depth = 10f; // Kích thước theo chiều sâu

    private MeshFilter meshFilter;
    private Mesh mesh;

    private void Start()
    {
        meshFilter = GetComponent<MeshFilter>();
        mesh = new Mesh();

        GenerateMesh();
    }

    private void GenerateMesh()
    {
        int vertexCount = (widthSegments + 1) * (depthSegments + 1);
        Vector3[] vertices = new Vector3[vertexCount];
        Vector2[] uvs = new Vector2[vertexCount]; // Tạo mảng tọa độ UV
        int[] triangles = new int[widthSegments * depthSegments * 6];

        // Tạo các đỉnh và tọa độ UV
        for (int z = 0; z <= depthSegments; z++)
        {
            for (int x = 0; x <= widthSegments; x++)
            {
                float xPos = (float)x / widthSegments * width;
                float zPos = (float)z / depthSegments * depth;
                vertices[z * (widthSegments + 1) + x] = new Vector3(xPos, 0, zPos);

                float u = (float)x / widthSegments; // Tính tọa độ u
                float v = (float)z / depthSegments; // Tính tọa độ v
                uvs[z * (widthSegments + 1) + x] = new Vector2(u, v); // Gán tọa độ UV
            }
        }

        // Tạo các tam giác
        int triangleIndex = 0;
        for (int z = 0; z < depthSegments; z++)
        {
            for (int x = 0; x < widthSegments; x++)
            {
                int bottomLeft = z * (widthSegments + 1) + x;
                int bottomRight = bottomLeft + 1;
                int topLeft = (z + 1) * (widthSegments + 1) + x;
                int topRight = topLeft + 1;

                triangles[triangleIndex] = bottomLeft;
                triangles[triangleIndex + 1] = topLeft;
                triangles[triangleIndex + 2] = bottomRight;
                triangles[triangleIndex + 3] = bottomRight;
                triangles[triangleIndex + 4] = topLeft;
                triangles[triangleIndex + 5] = topRight;

                triangleIndex += 6;
            }
        }

        mesh.vertices = vertices;
        mesh.uv = uvs; // Gán tọa độ UV vào mesh
        mesh.triangles = triangles;

        meshFilter.mesh = mesh;
    }
}
