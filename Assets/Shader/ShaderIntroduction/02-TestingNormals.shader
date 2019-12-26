Shader "Flecheria/ShaderIntroduction/02-TestingNormals"{
	Properties{
		_myColor("Example Color", Color) = (1,1,1,1)
		_myRange("Example Range", Range(0,5)) = 1
		_DiffuseTex("Diffuse Texture", 2D) = "white" {}
		// bump
		_BumpTex("Bump Texture", 2D) = "" {}
		_BumpIntensity("Bump Intensity", Range(0, 10)) = 1
		// reflection
		_ReflectionTex("Reflection Tex", CUBE) = "white" {}
		// factor
		_UniformScaleTex("Scale Texture", Range(0.1, 5)) = 1
	}
	SubShader{
		// suspend the ZBuffer
		// ZWrite Off

		// Rebder Queues
		// Background 1000
		// Geometry 2000 this is the default
		// AlphaTest 2450
		// Transparent 3000
		// Overlay 4000
		// custum queue indication inside the Shader
		Tags { "Queue" = "Geometry-300"}

		CGPROGRAM
		#pragma surface surf Lambert

		// color
		fixed4 _myColor;
		half _myRange;
		sampler2D _DiffuseTex;
		// bump and normal
		sampler2D _BumpTex;
		half _BumpIntensity;
		// reflection
		samplerCUBE _ReflectionTex;
		// factors
		float _UniformScaleTex;

		struct Input {
			float2 uv_DiffuseTex;
			float2 uv_BumpTex; // after the _ we have to get the same name of the relative texture
			float3 worldRefl; INTERNAL_DATA
		};

		// change order in bump and refection drastically change the result
		void surf(Input IN, inout SurfaceOutput o) {
			// color diffuse
			o.Albedo = (tex2D(_DiffuseTex, IN.uv_DiffuseTex * _UniformScaleTex) * _myRange * _myColor).rgb;

			// bump normal
			o.Normal = UnpackNormal(tex2D(_BumpTex, IN.uv_BumpTex * _UniformScaleTex));
			o.Normal *= float3(_BumpIntensity, _BumpIntensity, 1);

			// reflection
			o.Emission = texCUBE(_ReflectionTex, WorldReflectionVector(IN, o.Normal)).rgb;
		}

		ENDCG
	}
	Fallback "Diffuse"
}
