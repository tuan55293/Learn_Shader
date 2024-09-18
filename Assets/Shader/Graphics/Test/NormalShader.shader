Shader "Unlit/NormalShader"
{
    Properties
    {
        _Col1("Cor1",color) = (0,0,0,1)
        _Col2("Cor2",color) = (0,0,0,1)
        _Range1("_Range1",Range(0,1))  = 0
        _Range2("_Range2",Range(0,1))  = 0

        _CurrentChoose("CurrentChoose",Range(0,1)) = 0


        
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


            float4 _Col1;
            float4 _Col2;
            float4 _CurrentCol;
            float _Range1;
            float _Range2;
            float _CurrentChoose;
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 normal : NORMAL;
            };

            struct data
            {
                float2 a : TEXCOORD;
                float2 b : TEXCOORD1;
            };
            struct data2
            {
                float2 a : TEXCOORD;
                float2 b : TEXCOORD1;
            };


            float Unlerp(float a, float b, float v)
            {
                return (v-a) / (b-a);
            }

            v2f vert (appdata v,data d,data2 dd)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = v.normal;
                o.uv= v.uv;
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                float a = saturate( Unlerp(_Range1,_Range2,i.uv.x));
                float4 outcol = lerp(_Col1,_Col2,a);
                return outcol;
            }
            ENDCG
        }
    }
}
