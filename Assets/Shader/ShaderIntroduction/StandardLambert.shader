Shader "Flecheria/ShaderIntroduction/StandardLambert"
{
	Properties
	{
		_Color("Color", Color) = (1, 1, 1, 1)
		_DiffuseTex("Diffuse Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags 
		{
			"Queue" = "Geometry"
		}

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Lambert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		float4 _Color;
		sampler2D _DiffuseTex;

		struct Input
		{
			float2 uv_DiffuseTex;
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
