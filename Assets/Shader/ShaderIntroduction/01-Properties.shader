Shader "Flecheria/ShaderIntroduction/01-Properties"{
	Properties{
		_myColor("Example Color", Color) = (1,1,1,1)
		_myRange("Example Range", Range(0,5)) = 1
		_myTex("Example Texture", 2D) = "white" {}
		// emission
		_myTexEmission("Emission Texture", 2D) = "black" {}
		// reflection
		_myCube("Example Cube", CUBE) = "" {}
		_ReflectionIntensity("Reflection Intensity", Range(0,5)) = 1
		// factor
		_myFloat("Example Float", Float) = 0.5
		_myVector("Example Vector", Vector) = (0.5,1,1,1)
	}
	SubShader{

		CGPROGRAM
		#pragma surface surf Lambert

		// color
		fixed4 _myColor;
		half _myRange;
		sampler2D _myTex;
		// emission
		sampler2D _myTexEmission;
		// reflection
		samplerCUBE _myCube;
		half _ReflectionIntensity;
		// factors
		float _myFloat;
		float4 _myVector;

		struct Input {
			float2 uv_myTex;
			float3 worldRefl;
		};

		void surf(Input IN, inout SurfaceOutput o) {
			// different type of mixing between color and textures
			//o.Albedo = (tex2D(_myTex, IN.uv_myTex)).rgb;
			//o.Albedo = (tex2D(_myTex, IN.uv_myTex) * _myRange).rgb;
			//o.Albedo = (tex2D(_myTex, IN.uv_myTex) * _myRange * _myColor).rgb;
			//o.Albedo = (tex2D(_myTex, IN.uv_myTex) * _myRange + _myColor).rgb;
			// mixing 2
			//o.Albedo = (tex2D(_myTex, IN.uv_myTex)).rgb;
			//o.Albedo.g = 1;
			// mixing 3
			//float4 green = float4(0, 1, 0, 1);
			//o.Albedo = (tex2D(_myTex, IN.uv_myTex) * green).rgb;

			// color control
			o.Albedo = (tex2D(_myTex, IN.uv_myTex) * _myRange * _myColor).rgb;

			// emission control
			float3 colorEmission = (tex2D(_myTexEmission, IN.uv_myTex)).rgb;
			// reflection with cube texture
			float3 reflectionEmission = (texCUBE(_myCube, IN.worldRefl) * _ReflectionIntensity).rgb;
			o.Emission = colorEmission + reflectionEmission;
		}

		ENDCG
	}
	Fallback "Diffuse"
}
