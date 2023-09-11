Shader "Unlit/Mixtexture"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _RockTex ("RockTexture", 2D) = "white" {}
        _Pattern ("Pattern", 2D) = "white" {}
        _Color ("Color",color) = (1,1,1,1)
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

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4  worldPos : TEXCOORD1;
            };

            sampler2D _MainTex;
            sampler2D _RockTex;
            sampler2D _Pattern;
            float4 _MainTex_ST;

            float GetWave(float coord)
            {
                float wave = cos(coord * 6 * 5 - _Time.y)* 0.5 + 0.5;
                wave += 1-coord;
                return wave;
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv ;// TRANSFORM_TEX(v.uv, _MainTex);
                o.worldPos = mul(UNITY_MATRIX_M,v.vertex);
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                
                float2 projectXZ = i.worldPos.xz;


                float4 pattern = tex2D(_Pattern,i.uv);
                float4 moss = tex2D(_MainTex, projectXZ);
                float4 rock = tex2D(_RockTex, i.uv);
                float4 maintex = lerp(rock,moss,pattern);
                return maintex;
            }
            ENDCG
        }
    }
}
