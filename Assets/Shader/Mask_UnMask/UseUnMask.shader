Shader "Unlit/UseUnMask"
{
    //Shader này sử dụng cho obj mà muốn sử dụng cùng với Unmask Shader, khi dùng shader này thì obj sẽ bị đục một lỗ có hình dạng của Texture
    //hoặc vật thể có chứa shader Unmask khi rê obj vào vùng của mask.
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            ZWrite Off
            ZTest Off
            Cull Off
            Blend SrcAlpha OneMinusSrcAlpha
            //Kiểm tra stencil
            Stencil{
                ref 1 //Số tham chiếu
                comp NotEqual //Điều kiện tham chiếu
                pass Keep //Nếu vượt qua điều kiện tham chiếu thì thực hiện phương thức
            }

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
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
