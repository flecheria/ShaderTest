Shader "Flecheria/ShaderIntroduction/AE/01-AE-Outline"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_OutlineColor ("Outline Color", Color) = (1, 0, 0, 1)
		_OutlineWidth ("Outline Width", Range(0, 0.25)) = 0
	}
	SubShader
	{
		Tags
		{
			"Queue" = "Transparent"
		}

		// draw the outline wothout the Texture
		ZWrite off

		CGPROGRAM
		#pragma surface surf Lambert vertex:vert // look for the vertex shader

		struct Input
		{
			float2 uv_MainTex;
		};

		float _OutlineWidth;
		float4 _OutlineColor;
		sampler2D _MainTex;

		void vert(inout appdata_full v)
		{
			v.vertex.xyz += v.normal * _OutlineWidth;
		}

		void surf(Input IN, inout SurfaceOutput o)
		{
			o.Emission = _OutlineColor.rgb;
		}

		ENDCG

		// draw the object color with the texture
		ZWrite on

		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;

		struct Input
		{
			float2 uv_MainTex;
		};

		void surf(Input IN, inout SurfaceOutput o)
		{
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
		}
		ENDCG
    }
	Fallback "Diffuse"
}
