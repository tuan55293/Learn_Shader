Shader "Unlit/LitShaderr"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Gloss ("Gloss",float) = 1
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
                float3 normal : TEXCOORD1;
                float3 wPos : TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float3 _Color;
            float _Gloss;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.wPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //fixed4 col = tex2D(_MainTex, i.uv);

                // diffuseLighting
                float3 N =normalize( i.normal);
                float3 L =_WorldSpaceLightPos0.xyz;
                float3 diffuseLight = saturate(dot(L,N)) * _LightColor0.xyz ;


                // specular lighting

                float3 V = normalize(_WorldSpaceCameraPos - i.wPos);
                float3 R = reflect(-L,N);

                float3 specularLight = saturate(dot(V,R));

                specularLight = pow(specularLight,_Gloss);
                
                return float4(specularLight,1);


                return float4(diffuseLight,1);
            }
            ENDCG
        }
    }
}
