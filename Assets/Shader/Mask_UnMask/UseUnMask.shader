Shader "Unlit/UseUnMask"
{
    //Shader này sử dụng cho obj muốn sử dụng chế độ unmask khi rê qua obj sử dụng MaskCustom. (texture của obj này bị đục một lỗ tương tự như hình dạng texture của MaskCustom)
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
                comp Equal //Điều kiện tham chiếu, chỉ những pixel thỏa mãn điều kiện mới được thực hiện những bước tiếp theo để render lên màn hình.
                pass Keep //Nếu vượt qua điều kiện tham chiếu thì thực hiện phương thức này cho bộ đệm stencil, ở đây là vẫn giữ nguyên giá trị bộ đệm.(không phải giữ lại pixel)
                ReadMask 3
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
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
