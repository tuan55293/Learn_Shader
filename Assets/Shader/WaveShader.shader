
Shader "Custom/WaveShader" {
    Properties{
            _Color("Color",color) = (1,1,1,1)
            _Color1("Color1",color) = (1,1,1,1)
            //_StartRange("Start Range",Range(0,1)) = 0
            //_EndRange("End Range",Range(0,1)) = 1
            //_WaveHigh("WaveHigh",Range(0,1)) = 1
            _Freq("_Freq",Range(0,1)) = 1
            _MainTex("MainTex",2D) = "white"{}
            _RockTex("RockText",2D) = "white"{}
            _Pattern("RockText",2D) = "white"{}
             [KeywordEnum(Red, Green, Blue)] _SelectedColor ("Selected Color", Float) = 0
                
    }
        SubShader{
            Tags { "RenderType" = "Opaque"}
            LOD 100

            Pass {
                //ZTest LEqual
                //ZWrite Off
                //Cull Off
                //Blend One One

                CGPROGRAM

               #pragma vertex vert
               #pragma fragment frag
                #include "UnityCG.cginc"

                #define TAU 6.312850

                float4 _Color;
                float4 _Color1;
                float _WaveHigh;
                float _Freq;
                float _StartRange;
                float _EndRange;


                sampler2D _MainTex;
                sampler2D _Pattern;
                sampler2D _RockTex;

                struct appdata {
                    float4 vertex : POSITION;
                    float2 uv : TEXCOORD;
                    float3 normal : NORMAL;
                };

                struct v2f {
                    float2 uv : TEXCOORD;
                    float3 normal: NORMAL;
                    float4 vertex :SV_POSITION;
                };


                // Khu vực hàm có tác dụng làm nhiễu
                    float3 permute(float3 x) {
                        return frac((x * 34.0 + 1.0) * x);
                    }

                    float3 grad(float3 p) {
                        return 2.0 * permute(p) - 1.0;
                    }

                float perlinNoise3D(float3 p) {
                    float3 p0 = floor(p);
                    float3 p1 = p0 + 1.0;
    
                    float3 f = frac(p);
                    float3 f1 = f - 1.0;

                    float3 g0 = grad(p0);
                    float3 g1 = grad(p1);

                    float n000 = dot(g0, f);
                    float n100 = dot(g1, f1.xyy);
                    float n010 = dot(g0, f.yxy);
                    float n110 = dot(g1, f1.xyx);
                    float n001 = dot(g0, f.yyx);
                    float n101 = dot(g1, f1.xyy);
                    float n011 = dot(g0, f.yxy);
                    float n111 = dot(g1, f1.xyz);

                    float3 fade = smoothstep(0.0, 1.0, f);
                    float3 n00 = lerp(float3(n000, n010, n001), float3(n100, n110, n101), fade.x);
                    float3 n10 = lerp(float3(n011, n111, n010), float3(n111, n110, n101), fade.x);
                    float3 n0 = lerp(n00, n10, fade.y);
    
                    return lerp(n0.x, lerp(n0.y, n0.z, fade.z), 0.5) + 0.5;
                }
                 // Hết khu vực hàm có tác dụng trả về giá trị làm nhiễu.

                float UVCenter(float2 uv, float3 noise = (1,1,1))
                {
                    //float2 wavecenter = uv * 2 -1;
                    float lengthvector = length(uv);

                    float wave = cos((lengthvector  - _Time.y * _Freq   ) * TAU * 5)  * 0.5 + 0.5;

                    return wave;
                }
                v2f vert(appdata v) {
                    v2f o;
                    o.normal = v.normal;



                    //float WaveX = cos((v.uv.y - _Time.y*0.1f)*_Freq);
                    //float WaveY = cos((v.uv.x  * perlinNoise3D(v.uv *10) - _Time.y*0.1f)*_Freq);
                    //v.vertex.y = UVCenter(v.uv,v.uv) * _WaveHigh;
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    o.normal = v.normal;// UnityObjectToWorldNormal(v.normal);


                    o.uv = v.uv ;
                    return o;
                }



                float InverseLerp(float a, float b,float v)
                {
                    return (v-a) / (b-a);
                }

                float4 frag(v2f i) : SV_Target
                {
                    //float xOffset = cos(i.uv.x*50)*0.01;
                    //float t = cos(((i.uv.y + xOffset)  + _Time.y *0 ) * TAU * 5) * 0.5 + 0.5;
                    //t *= 1- i.uv.y;
                    //t *= abs(i.normal.y) < 0.99;
                    //float4 effect = lerp(_Color,_Color1,i.uv.y);
                    //float4 worldPos = mul(unity_ObjectToWorld, i.vertex);
                    //float4 localPos = mul(unity_WorldToObject,i.vertex);
                    return UVCenter(i.uv) ;

                }
                ENDCG
            }
        }
            FallBack "Diffuse"
}