Shader "Unlit/HealthBar"
{
    Properties
    {
        [NoScaleOffset]_MainTex ("Texture", 2D) = "white" {}
        _Health ("Health",Range(0,1)) = 1
        _Threshold("Threshold",Range(1,2)) = 1
        _BorderSize("Border Size",Range(0,0.5)) = 0.1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        LOD 100

        Pass
        {
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            //Blend One One

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
            };

            sampler2D _MainTex;

            float _Health;
            float _Threshold;
            float _BorderSize;


            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float InverseLerp(float a, float b, float v){
                return (v-a)/(b-a);
            }

            float4 frag (v2f i) : SV_Target
            {
                // Rounded corner clipping
                float2 coords = i.uv;
                coords.x *=8;
                float2 pointOnLineSeg = float2(clamp(coords.x,0.5,7.5),0.5);
                float SDF = distance(coords,pointOnLineSeg) * 2 - _Threshold;
                clip(-SDF);

                float borderSDF = SDF + _BorderSize;

                float pd = fwidth(borderSDF); // screen space partial derivative

                //float borderMask = step(0,-borderSDF);
                float borderMask = 1- saturate(borderSDF / pd);

                //return float4(borderMask.xxx,1);


                float3 healthbarColor = tex2D(_MainTex,float2(_Health,i.uv.y));
                float healthbarMask = i.uv < _Health;

                if(_Health < 0.3){
                    float flash = cos(_Time.y * 10) * 0.4 + 1;
                    healthbarColor *= flash;
                }


                return float4(healthbarColor.rgb * healthbarMask * borderMask, 1);
            }
            ENDCG
        }
    }
}
