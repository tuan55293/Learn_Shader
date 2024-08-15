Shader "Unlit/LitShaderr"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _lightDir ("Light",vector) = (0,0,0,0)
        _Color("Color",Color) = (1,0,1,1)
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

            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _lightDir;
            float3 _Color;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //fixed4 col = tex2D(_MainTex, i.uv);
                float3 N = i.normal;
                float3 L =_WorldSpaceLightPos0.xyz;
                float diffuseLight = max(0.1, dot(L,N)) ;
                return float4(diffuseLight * _LightColor0.xyz,1);
            }
            ENDCG
        }
    }
}
