Shader "Flecheria/ShaderIntroduction/08-CustomModel"
{
	Properties
	{
		_Color("Color", Color) = (1, 1, 1, 1)
		_DiffuseTex("Diffuse Texture", 2D) = "white" {}
		_RampTex("Ramp texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags
		{
			"Queue" = "Geometry"
		}

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		//#pragma surface surf BasicLambert
		//#pragma surface surf BasicBlinn
		#pragma surface surf ToonRamp

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		float4 _Color;
		sampler2D _DiffuseTex;
		sampler2D _RampTex;

		//half4 LightingBasicLambert(SurfaceOutput s, half3 lightDir, half atten)
		//{
		//	half NdotL = dot(s.Normal, lightDir);
		//	half4 c;
		//	// with light color influence
		//	//c.rgb = s.Albedo * _LightColor0.rgb * (NdotL * atten);
		//	// no light color influence
		//	c.rgb = s.Albedo * (NdotL * atten);
		//	c.a = s.Alpha;

		//	return c;
		//}

		//half4 LightingBasicBlinn(SurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
		//{
		//	half3 h = normalize(lightDir + viewDir);

		//	half diff = max(0, dot(s.Normal, lightDir));

		//	float nh = max(0, dot(s.Normal, h));
		//	float spec = pow(nh, 48.0);

		//	half4 c;
		//	c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec) * atten;
		//	c.a = s.Alpha;

		//	return c;
		//}

		half4 LightingToonRamp(SurfaceOutput s, half3 lightDir, fixed atten)
		{
			float diff = dot(s.Normal, lightDir);
			float h = diff * 0.5 + 0.5;
			float2 rh = h;
			float3 ramp = tex2D(_RampTex, rh).rgb;

			float4 c;
			c.rgb = s.Albedo * _LightColor0.rgb * ramp;
			c.a = s.Alpha;

			return c;
		}

		struct Input
		{
			float2 uv_DiffuseTex;
			float2 uv_RampTex;
		};

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf(Input IN, inout SurfaceOutput o)
		{
			o.Albedo = _Color.rgb;
			//o.Albedo = tex2D(_DiffuseTex, IN.uv_DiffuseTex).rgb;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
