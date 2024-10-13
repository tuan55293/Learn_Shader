Shader "Unlit/MultiLight"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _NormalMap("NormalMap",2D) = "bump"{}
        _Gloss("Gloss",Range(0,1)) = 0.5
        _Color("Color",Color) = (1,1,1,1)

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "LightingCustom.cginc"
            ENDCG
        }
    }
}
