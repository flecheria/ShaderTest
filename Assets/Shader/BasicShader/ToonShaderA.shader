Shader "Flecheria/Basic/ToonShaderA"
{
	Properties
	{
		_Color("Color", Color) = (0.5, 0.65, 1, 1)
		_MainTex("Main Texture", 2D) = "white" {}
		// add for ambient light calculation
		[HDR]
		_AmbientColor("Ambient Color", Color) = (0.4,0.4,0.4,1)
		// add for reflection calculation	
		[HDR]
		_SpecularColor("Specular Color", Color) = (0.9,0.9,0.9,1)
		_Glossiness("Glossiness", Float) = 32
		// add for rim control
		// Add as new properties.
		[HDR]
		_RimColor("Rim Color", Color) = (1,1,1,1)
		_RimAmount("Rim Amount", Range(0, 1)) = 0.716
		// Rim
		_RimThreshold("Rim Threshold", Range(0, 1)) = 0.1
	}
	SubShader
	{
		Tags
		{
			"LightMode" = "ForwardBase"
			"PassFlags" = "OnlyDirectional"
		}
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// add custom pragma
			#pragma multi_compile_fwdbase
			
			#include "UnityCG.cginc"
			// Add below the existing #include "UnityCG.cginc"
			// this permit to get information about light in the scene
			#include "Lighting.cginc"
			// As a new include, below the existing ones.
			#include "AutoLight.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float4 uv : TEXCOORD0;
				// Inside the appdata struct.
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				// Inside the v2f struct.
				float3 worldNormal : NORMAL;
				// for reflection
				float3 viewDir : TEXCOORD1;

				SHADOW_COORDS(2)
			};

			// variables
			sampler2D _MainTex;
			float4 _MainTex_ST;
			// ambient color
			float4 _AmbientColor;
			// reflection information
			float _Glossiness;
			float4 _SpecularColor;
			// Rim dot controls
			float4 _RimColor;
			float _RimAmount;
			// Rim
			float _RimThreshold;
			
			v2f vert (appdata v)
			{
				// standard shader
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				// custom part
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				// for reflection
				o.viewDir = WorldSpaceViewDir(v.vertex);

				TRANSFER_SHADOW(o)

				return o;
			}
			
			float4 _Color;

			float4 frag (v2f i) : SV_Target
			{
				// entry Texture
				float4 sample = tex2D(_MainTex, i.uv);

				// DIFFUSE BLINN-PHONG MODEL
				float3 normal = normalize(i.worldNormal);
				float NdotL = dot(_WorldSpaceLightPos0, normal);

				// In the fragment shader, above the existing lightIntensity declaration.
				float shadow = SHADOW_ATTENUATION(i);
				// step 2.0 - Below the NdotL declaration.
				//float lightIntensity = NdotL > 0 ? 1 : 0;
				// step 2.1 - NdotL with smooth function
				//float lightIntensity = smoothstep(0, 0.01, NdotL);
				// step 2.2 - NdotL with smooth function with shadow attenuation 
				float lightIntensity = smoothstep(0, 0.01, NdotL * shadow);

				// step 3 - Add below the lightIntensity declaration.
				float4 light = lightIntensity * _LightColor0;

				// SPECULAR CALCULATION
				// Add to the fragment shader, above the line sampling _MainTex.
				float3 viewDir = normalize(i.viewDir);
				float3 halfVector = normalize(_WorldSpaceLightPos0 + viewDir);
				float NdotH = dot(normal, halfVector);
				float specularIntensity = pow(NdotH * lightIntensity, _Glossiness * _Glossiness);

				// RIM LIGHT
				// simple rim dot
				float4 rimDot = 1 - dot(viewDir, normal);
				// 1.0 optional: rim dot with smooth step
				//float rimIntensitky = smoothstep(_RimAmount - 0.01, _RimAmount + 0.01, rimDot);
				// 1.1 optional: Add above the existing rimIntensity declaration, replacing it.
				//float rimIntensity = rimDot * NdotL;
				// 1.2 optional
				float rimIntensity = rimDot * pow(NdotL, _RimThreshold);

				rimIntensity = smoothstep(_RimAmount - 0.01, _RimAmount + 0.01, rimIntensity);
				// final rim output
				float4 rim = rimIntensity * _RimColor;

				// FINAL OUTPUT
				// step 1
				//return _Color * sample * NdotL;
				// step 2
				//return _Color * sample * (_AmbientColor + lightIntensity);
				// step 3
				//return _Color * sample * (_AmbientColor + light);
				// step 4
				//return _Color * sample * (_AmbientColor + light + specularIntensity);
				// step 5.0
				//return _Color * sample * (_AmbientColor + light + specularIntensity + rimDot);
				// step 5.1
				return _Color * sample * (_AmbientColor + light + specularIntensity + rim);
			}
			ENDCG
		}

		// Insert just after the closing curly brace of the existing Pass.
		UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
	}
}