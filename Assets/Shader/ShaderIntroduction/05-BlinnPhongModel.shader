Shader "Flecheria/ShaderIntroduction/05-BlinnPhongModel"
{
	Properties
	{
		_Color("Color", Color) = (1, 1, 1, 1)
		_DiffuseTex("Diffuse Texture", 2D) = "white" {}
		_SpecColor("Colour", Color) = (1, 1, 1, 1)
		_Spec("Specular", Range(0, 1)) = 0.5
		_Gloss("Gloss", Range(0, 1)) = 0.5
	}
	SubShader
	{
		Tags
		{
			"Queue" = "Geometry"
		}

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf BlinnPhong

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		float4 _Color;
		sampler2D _DiffuseTex;
		half _Spec;
		fixed _Gloss;

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
			o.Specular = _Spec;
			o.Gloss = _Gloss;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
