
// Code xử lý tạo sóng mặt nước kiểu từ tâm lan rộng ra với kích thước khác nhau.
// Ngoài ra có thể di chuyển tâm của sóng đi khắp nới trên bề mặt, và có thể có nhiều tâm sóng trên cùng một mặt nước.


Shader "Unlit/WaveCenter"
{
    Properties
    {
        // Các biến.
        _MainTex ("Texture", 2D) = "white" {}
        _Freq ("Freq",float) = 0
        _High ("High",float) = 0
        _numberOfArray("num",int) = 0
        _number("number",float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue" = "Transparent"}
        LOD 100

        Pass
        {
            ZWrite On
            Blend One One
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #define TAU 6.312850
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Freq;
            float _High;
            float3 _PointCenter;
            float3 _PointCenter2;
            float _numberOfArray;
            float _number;
            float4  myCenter[1000];
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            //Perlin noise

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
            //End perlin noise

            //Voronoise

            inline float2 unity_voronoi_noise_randomVector (float2 UV, float offset)
            {
                float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
                UV = frac(sin(mul(UV, m)) * 46839.32);
                return float2(sin(UV.y*+offset)*0.5+0.5, cos(UV.x*offset)*0.5+0.5);
            }

            void Unity_Voronoi_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
            {
                float2 g = floor(UV * CellDensity);
                float2 f = frac(UV * CellDensity);
                float t = 8.0;
                float3 res = float3(8.0, 0.0, 0.0);

                for(int y=-1; y<=1; y++)
                {
                    for(int x=-1; x<=1; x++)
                    {
                        float2 lattice = float2(x,y);
                        float2 offset = unity_voronoi_noise_randomVector(lattice + g, AngleOffset);
                        float d = distance(lattice + offset, f);
                        if(d < res.x)
                        {
                            res = float3(d, offset.x, offset.y);
                            Out = res.x;
                            Cells = res.y;
                        }
                    }
                }
            }

            //End voronoise


            // Xử lý tạo ra vector sóng  từ tâm
            float UVCenter(float2 uv, float3 pivot){
                
                float2 reuv = float2(pivot.x/40,pivot.z/40);
                
                //float2 remap = reuv * 2 - 1;
                
                float lDis = length(uv - reuv);
                float center = cos((lDis - _Time.y * _Freq *0.1)*100) * 0.5 + 0.5;
                center *= saturate(0.2 -lDis);
                return center;
            }

            v2f vert (appdata v)
            {
                v2f o;

                // xử lý tạo sóng bằng cách di chuyển các đỉnh mesh theo chiều y với thông số vector sóng đã tính,và áp dụng với nhiều tâm sóng.
                float totalwave = 0;
                for(int i = 0; i < _numberOfArray;i++)
                {
                    totalwave += UVCenter(v.uv,myCenter[i]);
                }
                v.vertex.y = totalwave * _High;
                 //v.vertex.y = UVCenter(v.uv,_PointCenter)*_High;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                // sample the texture

                //Hiển thị texture dưới dạng có voronoise và hiệu ứng blend.
                fixed4 col = tex2D(_MainTex, i.uv);
                float outt;
                float cell;
                Unity_Voronoi_float(i.uv,3 * _Time.y,4,outt,cell);
                return  lerp(col, pow(outt,_number), pow(outt,_number));
                //UVCenter(i.uv);
            }
            ENDCG
        }
    }    
}
