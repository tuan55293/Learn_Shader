Shader "Unlit/EffectFullScreen"
{
    Properties
    {
        [NoScaleOffset]_MainTex ("Texture", 2D) = "white" {}
        _A ("A",Range(0,0.4)) = 0.2
        _B ("B",Range(0.6 ,1)) = 0.8
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Transparent" "Queue" = "Transparent"
        }
        LOD 100
        Pass
        {

            Cull Off
            //Blend SrcAlpha OneMinusSrcAlpha
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_instancing

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _A;
            float _B;
            float _Smooth;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                float4 col = tex2D(_MainTex, i.uv);
                float GrayColor = dot(col.rgb, float3(0.2126, 0.7152, 0.0722));
                float4 GBRColor = col.gbra;

                if (i.uv.x < _A)
                {
                    return GrayColor;
                }
                if (_Smooth == 1)
                {
                    if (i.uv.x > _A && i.uv.x < _B)
                    {
                        float blendFactor = smoothstep(_A, _B, i.uv.x);
                        return lerp(GrayColor, GBRColor, blendFactor);
                    }
                }
                if (i.uv.x > _B)
                {
                    return GBRColor;
                }
                return col;
            }
            ENDHLSL
        }
    }
}