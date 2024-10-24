Shader "Unlit/MultiLight"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        [NoScaleOffset]_NormalMap("NormalMap",2D) = "bump"{}
        _NormalIntensity("Normal Intensity",Range(0,1))=0
        _Gloss("Gloss",Range(0,1)) = 0.5
        _Color("Color",Color) = (1,1,1,1)

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            Tags {"LightMode" = "ForwardBase"}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "LightingCustom.cginc"
            ENDCG
        }
        Pass
        {
            Tags {"LightMode" = "ForwardAdd"}
            Blend One One
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdadd
            #include "LightingCustom.cginc"
            ENDCG
        }
    }
}
