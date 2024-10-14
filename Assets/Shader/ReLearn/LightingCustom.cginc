#include "UnityCG.cginc"
#include "AutoLight.cginc"
#include "Lighting.cginc"

struct appdata
{
    float4 vertex : POSITION;
    float2 uv : TEXCOORD0;
    float4 tangent : TANGENT;
    float3 normal : NORMAL;
};

struct v2f
{
    float2 uv : TEXCOORD0;
    float4 vertex : SV_POSITION;
    float3 wNormal : TEXCOORD1;
    float3 tangent : TEXCOORD2;
    float3 bitangent : TEXCOORD3;
    float3 wPos : TEXCOORD4;
    LIGHTING_COORDS(5,6)
};

sampler2D _MainTex;
float4 _MainTex_ST;
sampler2D _NormalMap;
float _Gloss;
float4 _Color;

v2f vert(appdata v)
{
    v2f o;
    o.vertex = UnityObjectToClipPos(v.vertex);
    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
    o.tangent = UnityObjectToWorldDir(v.tangent.xyz);
    o.wPos = mul(unity_ObjectToWorld, v.vertex);
    o.wNormal = UnityObjectToWorldNormal(v.normal);
    o.bitangent = cross(o.wNormal, o.wPos) * v.tangent.w;
    TRANSFER_VERTEX_TO_FRAGMENT(o);
    return o;
}

float4 frag(v2f i) : SV_Target
{
    float4 texCol = tex2D(_MainTex, i.uv);

    float3 N = normalize(i.wNormal);
    float3 L = normalize(UnityWorldSpaceLightDir(i.wPos));
    float3 V = normalize(_WorldSpaceCameraPos - i.wPos);
    float3 HalfVector = normalize(L + V);

    float attenuation = LIGHT_ATTENUATION(i);
    
    float lambert = saturate(dot(L, N));
    float3 diffuse = lambert * attenuation * _LightColor0.xyz;

    float3 specularLight = saturate(dot(N, HalfVector)) * (lambert > 0);
    float specularExponent = exp2(_Gloss * 10) + 2;

    specularLight = pow(specularLight, specularExponent) * _Gloss;
    specularLight *= _LightColor0.xyz;

    return float4(texCol * _Color * diffuse + specularLight, 1);
}
