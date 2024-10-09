#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "AutoLight.cginc"
#pragma multi_compile_instancing
struct appdata 
{
    float4 vertex : POSITION;
    float2 uv : TEXCOORD0;
    float4 tangent : TANGENT; // x,y,z  = tangent dir, w = tangent sign
    float3 normal : NORMAL;
};

struct v2f
{
    float2 uv : TEXCOORD0;
    float4 vertex : SV_POSITION;
    float3 normal : TEXCOORD1;
    float3 tangent : TEXCOORD2;
    float3 bitangent : TEXCOORD3;
    float3 wPos : TEXCOORD4;
    LIGHTING_COORDS(5,6)
};

sampler2D _Albedo;
float4 _Albedo_ST;
sampler2D _NormalMap;
float _NormalIntensity;
float4 _Color;
float _Gloss;

v2f vert(appdata v)
{
    v2f o;
    o.vertex = UnityObjectToClipPos(v.vertex);
    o.uv = TRANSFORM_TEX(v.uv, _Albedo);
    o.normal = UnityObjectToWorldNormal(v.normal);
    o.wPos = mul(unity_ObjectToWorld, v.vertex); //Tọa độ đỉnh trong thế giới.
    o.tangent = UnityObjectToWorldDir(v.tangent.xyz);
    o.bitangent = cross(o.normal,o.tangent);
    //o.bitangent = cross(o.tangent,o.normal);
    o.bitangent *= v.tangent.w * unity_WorldTransformParams.w;
    TRANSFER_VERTEX_TO_FRAGMENT(o)
    return o;
}

float4 frag(v2f i) : SV_Target
{
    float3 tex = tex2D(_Albedo, i.uv);
    float3 surfaceColor = tex * _Color.rgb;


    float3 tangentSpaceNormal = UnpackNormal(tex2D(_NormalMap, i.uv));

    tangentSpaceNormal = lerp(float3(0,0,1), tangentSpaceNormal, _NormalIntensity);
    
    float3x3 mtxTangToWorld = {
        i.tangent.x, i.bitangent.x, i.normal.x,
        i.tangent.y, i.bitangent.y, i.normal.y,
        i.tangent.z, i.bitangent.z, i.normal.z
    };

    float3 N = mul(mtxTangToWorld,tangentSpaceNormal);

    // Blinn-Phong lighting...
    // diffuseLighting
    //float3 N = normalize(i.normal); //normal vector in plane
    //float3 L = _WorldSpaceLightPos0.xyz; // Dir light from plane to source light
    float3 L = normalize(UnityWorldSpaceLightDir(i.wPos));
    
    float attenuation =  LIGHT_ATTENUATION(i);
    
    float lambert = saturate(dot(L, N));
    float3 diffuseLight = (lambert * attenuation) * _LightColor0.xyz;


    // specular lighting
    float3 V = normalize(_WorldSpaceCameraPos - i.wPos);
    float3 HalfVector = normalize(L + V);
    float3 specularLight = saturate(dot(HalfVector, N)) * (lambert > 0);
    float specularExponent = exp2(_Gloss * 11) + 2;
    specularLight = pow(specularLight, specularExponent) * _Gloss * attenuation; // Nhân với _Gloss để khi Gloss bằng 0 thì sẽ không có hiện tượng bóng sáng mà sẽ là màu nguyên bản
    specularLight *= _LightColor0.xyz;
    float fresnel = 0; //(1-dot(V,N))*(cos(_Time.y * 5) *0.5 + 0.5);
    return float4(diffuseLight * surfaceColor + specularLight + fresnel, 1);               
}