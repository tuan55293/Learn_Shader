#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "AutoLight.cginc"
struct appdata
{
    float4 vertex : POSITION;
    float2 uv : TEXCOORD0;
    float3 normal : NORMAL;
};

struct v2f
{
    float2 uv : TEXCOORD0;
    float4 vertex : SV_POSITION;
    float3 normal : TEXCOORD1;
    float3 wPos : TEXCOORD2;
    LIGHTING_COORDS(3,4)
};

sampler2D _MainTex;
float4 _MainTex_ST;
float4 _Color;
float _Gloss;

v2f vert(appdata v)
{
    v2f o;
    o.vertex = UnityObjectToClipPos(v.vertex);
    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
    o.normal = UnityObjectToWorldNormal(v.normal);
    o.wPos = mul(unity_ObjectToWorld, v.vertex);
    TRANSFER_VERTEX_TO_FRAGMENT(o)
    return o;
}

float4 frag(v2f i) : SV_Target
{


    // Blinn-Phong lighting...
    // diffuseLighting
    float3 N = normalize(i.normal); //normal vector in plane
    float3 L = _WorldSpaceLightPos0.xyz; // Dir light from plane to source light
    float lambert = saturate(dot(L, N));
    float3 diffuseLight = (lambert + 0.06) * _LightColor0.xyz;


    // specular lighting
    float3 V = normalize(_WorldSpaceCameraPos - i.wPos);
    float3 HalfVector = normalize(L + V);
    float3 specularLight = saturate(dot(HalfVector, N)) * (lambert > 0);
    float specularExponent = exp2(_Gloss * 11) + 2;
    specularLight = pow(specularLight, specularExponent) * _Gloss; // Nhân với _Gloss để khi Gloss bằng 0 thì sẽ không có hiện tượng bóng sáng mà sẽ là màu nguyên bản
    specularLight *= _LightColor0.xyz;
    float fresnel = 0; //(1-dot(V,N))*(cos(_Time.y * 5) *0.5 + 0.5);
    return float4(diffuseLight * _Color.xyz + specularLight + fresnel, _Color.w);               
}