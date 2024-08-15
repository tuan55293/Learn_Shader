Shader "Unlit/MaskCustom 1"
{
    //Shader này là một mặt nạ
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
            // Tạo mask và ghi đè tất cả pixel của obj vào bộ đện stencil
            Stencil{
                ref 3
                comp Equal
                WriteMask 3
                ReadMask 1
                pass replace
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

                //Loại bỏ phần vùng trống của texture nơi có alpha bé hơn 0.1f (đồng thời không ghi pixel này vào stencil buffer)
                //Pixel nào được ghi vào buffer thì mới có dữ liệu để tham chiếu và so sánh, không có đồng nghĩa với việc loại bỏ việc so sánh hoặc cho kết quả không bằng nhau nếu phép so sánh là so sánh bằng (vì sẽ có giá trị mặc định của buffer nếu không ghi vào).
                if(col.a<=0.1){ 
                    discard;
                }
                //Phần còn lại thì cho alpha = 0 để giấu đi màu của texture (và vẫn được ghi vào stencil buffer bình thường)
                //else{
                //    col.a = 0;
                //}
                return col;
            }
            ENDCG
        }
    }
}
