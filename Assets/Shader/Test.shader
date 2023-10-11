Shader"Unlit/Test"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MainTex1 ("Texture", 2D) = "white" {}

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


            sampler2D _MainTex;
            sampler2D _MainTex1;
            float4 _MainTex_ST;
            float4 _MainTex1_ST;
            
            
            float4 inputremap;
            float2 inminmax;
            float2 outminmax;

            void Remap(float4 In, float2 InMinMax, float2 OutMinMax, out float4 Out)
            {
                Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }

            v2f vert (appdata v)
            {
                v2f o;
                
                float4 Outeffect;
                float4 colorTex1;
                //float4 UVforTexlod;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv; //TRANSFORM_TEX(v.uv, _MainTex);
                o.uv1 = v.uv/10;
                o.uv1.y += _Time.y/5;
                Remap(inputremap,inminmax,outminmax,Outeffect);
                float4 UVforTexlod = {o.uv1.x,o.uv1.y,0,0};
                colorTex1 = tex2Dlod(_MainTex1,UVforTexlod);

                o.uv.x += Outeffect * colorTex1.x;
                o.uv.y += 1;
                //o.uv1.x += _Time.y;
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                // sample the texture
                float4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
