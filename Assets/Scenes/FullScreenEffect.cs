using UnityEngine;

[ExecuteInEditMode]
public class FullScreenEffect : MonoBehaviour
{
    public Material effectMaterial;

    [Range(0, 0.4f)]
    public float A = 0.2f;
    
    [Range(0.6f, 1)]
    public float B=0.8f;

    public bool Smooth;

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        effectMaterial.SetFloat("_A", A);
        effectMaterial.SetFloat("_B", B);
        int smooth = Smooth ? 1 : 0;
        effectMaterial.SetFloat("_Smooth",smooth);
        if (effectMaterial != null)
        {
            Graphics.Blit(source, destination, effectMaterial);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }
}
