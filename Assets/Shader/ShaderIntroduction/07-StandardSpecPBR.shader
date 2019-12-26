Shader "Flecheria/ShaderIntroduction/07-StandardSpecPBR"
{
	Properties
	{
		_Color("Color", Color) = (1, 1, 1, 1)
		_MetallicTex("Metallic (R)", 2D) = "white" {}
		_SpecColor("Specular", Color) = (1,1,1,1)
	}
	SubShader
	{
		Tags
		{
			"Queue" = "Geometry"
		}

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf StandardSpecular

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		fixed4 _Color;
		sampler2D _MetallicTex;

		struct Input
		{
			//float2 uv_DiffuseTex;
			float2 uv_MetallicTex;
		};

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf(Input IN, inout SurfaceOutputStandardSpecular o)
		{
			o.Albedo = _Color.rgb;
			o.Smoothness = tex2D(_MetallicTex, IN.uv_MetallicTex).r;
			o.Specular = _SpecColor.rgb;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
