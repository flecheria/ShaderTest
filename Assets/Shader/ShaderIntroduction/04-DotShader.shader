Shader "Flecheria/ShaderIntroduction/04-DotShader"
{
	Properties
	{
		_DiffuseTex("Diffuse Texture", 2D) = "white" {}
		_RimColor("RimColor", Color) = (0.5, 0, 0.5, 1)
		_RimPower("RimPower", Range(0, 10)) = 1 
	}
	SubShader
	{
		// note
		// https://answers.unity.com/questions/38138/fresnelrim-reflective-shader.html
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Lambert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _DiffuseTex;
		fixed4 _RimColor;
		float _RimPower;

		struct Input
		{
			float2 uv_DiffuseTex;
			float3 viewDir;
			float3 worldPos;
		};

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		// methods
		inline float CalcFresnel(float3 viewDir, float3 h, float fresnelValue)
		{
			float fresnel = pow(1.0 - dot(normalize(viewDir), h), 5.0);
			fresnel += fresnelValue * (1.0 - fresnel);
			return fresnel;
		}

		void surf(Input IN, inout SurfaceOutput o)
		{
			//half rim = 1 - dot(normalize(IN.viewDir), o.Normal);
			half rim = 1 - saturate(dot(normalize(IN.viewDir), o.Normal));
			//o.Albedo = tex2D(_DiffuseTex, IN.uv_DiffuseTex).rgb;
			//o.Albedo = float3(rim, 1, 1 - rim);

			// fresnel
			//o.Emission = _RimColor.rgb * pow(rim, _RimPower);
			//o.Emission = _RimColor.rgb * CalcFresnel(IN.viewDir, o.Normal, _RimPower);
			//o.Emission = _RimColor.rgb * rim > 0.8 ? rim : 0;
			//o.Emission = rim > 0.8 ? float3(1, 0, 0) : rim > 0.3 ? float3(0, 0.5, 1) : 0;
			//o.Emission = IN.worldPos.y > 0.5 ? float3(0, 1, 0) : 0;
			//o.Emission = frac(IN.worldPos.y * 10 * 0.5) > 0.15 ? float3(0, 1, 0) : float3(1, 0, 0);
			o.Emission = frac(IN.worldPos.y * 10 * 0.5) > 0.45 ? float3(0, 1, 0) * rim : float3(1, 0, 0) * rim;
		}
		ENDCG
	}
		FallBack "Diffuse"
}
