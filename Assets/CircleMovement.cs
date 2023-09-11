using UnityEngine;

public class CircleMovement : MonoBehaviour
{
    public Transform centerPoint; // Điểm trung tâm bạn muốn vật thể di chuyển xung quanh.
    public float radius = 2f; // Bán kính của vòng tròn di chuyển.

    private float angle = 0f; // Góc hiện tại của vật thể.
    public float speed;
    public float offset; // góc bù thêm;

    public bool re;

    private void Update()
    {
        // Tính toán vị trí mới của vật thể dựa trên góc và bán kính.
        float x;
        float z;
        if (re == false)
        {
            x = centerPoint.position.x + radius * Mathf.Sin((angle + offset) * Mathf.Deg2Rad);
            z = centerPoint.position.z + radius * Mathf.Cos((angle + offset) * Mathf.Deg2Rad);
        }
        else
        {
            x = centerPoint.position.x + radius * Mathf.Cos((angle + offset) * Mathf.Deg2Rad);
            z = centerPoint.position.z + radius * Mathf.Sin((angle + offset) * Mathf.Deg2Rad);
        }

        // Cập nhật vị trí của vật thể.
        transform.position = new Vector3(x, transform.position.y, z);

        // Tăng góc để vật thể tiếp tục di chuyển xung quanh vòng tròn.
        angle += Time.deltaTime * speed; // Tốc độ di chuyển (điều chỉnh theo ý muốn).
    }
}
