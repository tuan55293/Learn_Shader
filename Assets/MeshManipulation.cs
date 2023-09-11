using UnityEngine;

public class MeshManipulation : MonoBehaviour
{
    Mesh mesh;
    public Vector3[] vertices;
    public int[] triangles;

    void Start()
    {
        // Tạo mesh và gán nó cho MeshFilter của GameObject
        mesh = new Mesh();
        GetComponent<MeshFilter>().mesh = mesh;

        // Khởi tạo danh sách các đỉnh và tạo mesh ban đầu
        CreateMesh();
    }

    void CreateMesh()
    {
        // Khởi tạo danh sách các đỉnh

        // Gán danh sách đỉnh vào mesh
        mesh.vertices = vertices;

        // Định nghĩa các tam giác bằng cách chỉ định các chỉ số của đỉnh


        // Gán danh sách tam giác vào mesh
        mesh.triangles = triangles;
    }

    void Update()
    {
        // Thay đổi tọa độ của các đỉnh
        //vertices[2] = new Vector3(1, 1, Mathf.Sin(Time.time)); // Thay đổi tọa độ y của đỉnh 2 theo thời gian
        mesh.vertices = vertices; // Gán lại giá trị cho mesh để cập nhật
        mesh.triangles = triangles;
    }
}
