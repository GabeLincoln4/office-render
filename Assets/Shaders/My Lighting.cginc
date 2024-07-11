// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

#if !defined(MY_LIGHTING_INCLUDED)
#define MY_LIGHTING_INCLUDED

#include "UnityPBSLighting.cginc"
#include "AutoLight.cginc"

float4 _Tint;
sampler2D _MainTex;
sampler2D _SplatMap, _Texture1, _Texture2;
float4 _MainTex_ST;

float _Metallic;
float _Smoothness;

struct VertexData {
	float4 position : POSITION;
	float3 normal : NORMAL;
	float2 uv : TEXCOORD0;
};

struct Interpolators {
	float4 position : SV_POSITION;
	float2 uv : TEXCOORD0;
	float3 normal : TEXCOORD1;
	float3 worldPos : TEXCOORD2;
	float2 uvSplat : TEXCOORD3;
};

Interpolators MyVertexProgram (VertexData v) {
	Interpolators i;
	i.position = UnityObjectToClipPos(v.position);
	i.worldPos = mul(unity_ObjectToWorld, v.position);
	i.normal = UnityObjectToWorldNormal(v.normal);
	i.uv = TRANSFORM_TEX(v.uv, _MainTex);
	i.uvSplat = v.uv;
	return i;
}

UnityLight CreateLight (Interpolators i) {
	UnityLight light;
	light.dir = normalize(_WorldSpaceLightPos0.xyz - i.worldPos);
	UNITY_LIGHT_ATTENUATION(attenuation, 0, i.worldPos);
	light.color = _LightColor0.rgb * attenuation;
	light.ndotl = DotClamped(i.normal, light.dir);
	return light;
}

float4 MyFragmentProgram (Interpolators i) : SV_TARGET {
	i.normal = normalize(i.normal);
	float4 splatMap;
	float4 PBS;
	float4 totalTexture;
	
	float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);

	
	float4 splat = tex2D(_SplatMap, i.uvSplat);
	splatMap = 
		tex2D(_Texture1, i.uv) * splat.r +
		tex2D(_Texture2, i.uv) * (1 - splat.r);

	float3 albedo = splatMap.rgb * _Tint.rgb;

	float3 specularTint;
	float oneMinusReflectivity;
	albedo = DiffuseAndSpecularFromMetallic(
		albedo, _Metallic, specularTint, oneMinusReflectivity
	);

	UnityIndirect indirectLight;
	indirectLight.diffuse = 0;
	indirectLight.specular = 0;

	PBS =
		UNITY_BRDF_PBS(
		albedo, specularTint,
		oneMinusReflectivity, _Smoothness,
		i.normal, viewDir,
		CreateLight(i), indirectLight
	);

	return PBS;
}

#endif