Shader "Hidden/NewImageEffectShader"
{
    Properties
    {
        _tex ("Texture", 2D) = "white" {}
        _texx ("Texture", 2D) = "white" {}
        _offset("offset",float) = 0
    }
    SubShader
    {
        // No culling or depth
        Pass
        {
                        //ZWrite Off
            Cull Off
            Blend One One
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

             sampler2D _tex;
              float4 _tex_ST;
              float _offset;
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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                
                o.uv = TRANSFORM_TEX(v.uv, _tex);
                return o;
            }



            fixed4 frag (v2f i) : COLOR
            {
                fixed4 col = tex2D(_tex, i.uv);
                // just invert the colors
                //col.rgb = 1 - col.rgb;
                col.x = cos(((i.uv.x+i.uv.y)  +_Time.y*0.7)*10)*0.5+0.5;
                col.y = cos(((i.uv.x+i.uv.y*i.uv.x*2)  +_Time.y*0.7)*10)*0.5+0.5;
                //col.z = cos(((i.uv.x+i.uv.y*3.14*cos(i.uv.x))  +_Time.y*0.7)*10)*0.5+0.5;
                if(col.y>0.5 && col.z>0.5){
                    col.x = 0;
                    col.y=0;
                    col.z=0;
                }
                return col;
            }
            ENDCG
        }
        Pass
        {
            //ZWrite Off
            Cull Off
            Blend One One
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

             sampler2D _texx;
             float4 _texx_ST;
             float _offset;
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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);

                o.uv = v.uv;
                o.uv = TRANSFORM_TEX(v.uv, _texx);
                return o;
            }



            fixed4 frag (v2f i) : COLOR
            {
                fixed4 col = tex2D(_texx, i.uv);
                // just invert the colors
                //col.rgb = 1 - col.rgb;
                col.x = cos(((i.uv.x+i.uv.y)  -_Time.y*0.7)*10)*0.5+0.5;
                col.y = cos(((i.uv.x+i.uv.y*i.uv.x*2)  -_Time.y*0.7)*10)*0.5+0.5;
                //col.z = cos(((i.uv.x+i.uv.y*3.14*cos(i.uv.x))  +_Time.y*0.7)*10)*0.5+0.5;
                if(col.y>0.5 && col.z>0.5){
                    col.x = 0;
                    col.y=0;
                    col.z=0;
                }
                return col;
            }
            ENDCG
        }

    }
}
