﻿Shader "Unlit/LightingTestMulti"
{
    Properties
    {
        _Albedo ("Albedo", 2D) = "white" {}
        [NoScaleOffset]_NormalMap ("Normal Map", 2D) = "bump"{}
        _NormalIntensity("Normal Intensity",Range(0,1))=0
        _Gloss ("Gloss",Range(0,1)) = 0
        _Color("Color",Color) = (1,0,1,1)
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderQueue" = "Geometry"}
        LOD 100

        Pass
        {
            Tags { "LightMode" = "ForwardBase" }
            //Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "FGLighting.cginc"
            
            ENDCG
        }

        Pass
        {
            Tags { "LightMode" = "ForwardAdd" }
            Blend One One
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdadd
            #include "FGLighting.cginc"
            
            ENDCG
        }
    }
}
