Shader "Unlit/2D_water_frag"
{
    Properties
    {
        _MainTexx ("Texture", 2D) = "white" {}
        _MainTexx1 ("Texture1", 2D) = "white" {}

        inputremap ("inputremap",vector) = (1,1,1,1)
        inminmax ("inminmax",vector) = (1,1,1,1)
        outminmax ("outminmax",vector) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            Cull off

            Ztest Off

            Zwrite Off

        ZTest Off
        ZWrite Off
        Cull Off
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
                float2 uv1 : TEXCOORD2;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTexx;
            sampler2D _MainTexx1;
            float4 inputremap;
            float2 inminmax;
            float2 outminmax;
            float4 _MainTexx_ST;


            void Remap(float4 In, float2 InMinMax, float2 OutMinMax, out float4 Out)
            {
                Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTexx);
                o.uv1 = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float4 Outeffect;
                float2 colorTex1;
                i.uv1.x += _Time.y/10;
                float2 UVforTexlod = i.uv1;
                Remap(inputremap,inminmax,outminmax,Outeffect);
                colorTex1 = tex2D(_MainTexx1,UVforTexlod);
                i.uv.x += Outeffect * colorTex1.x;
                i.uv.y *=-1;
                fixed4 col = tex2D(_MainTexx, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
