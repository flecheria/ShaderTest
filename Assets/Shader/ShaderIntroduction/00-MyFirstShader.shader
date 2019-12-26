﻿Shader "Flecheria/ShaderIntroduction/00-MyFirstShader"
{
    // https://docs.unity3d.com/Manual/SL-Properties.html
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_Normal("Normal", Color) = (1,1,1,1)
		_Emission("Emission", Color) = (0,0,0,1)
		_eIntensity("EmissionIntensity", Range(0.0, 1.0)) = 1.0
    }
    SubShader
    {
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Lambert

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _Color;
		fixed4 _Normal;
		fixed4 _Emission;
		fixed _eIntensity;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

		// SurfaceOutput is used cause we are in Lambert light model
        void surf (Input IN, inout SurfaceOutput o)
        {
			o.Albedo = _Color.rgb;
			o.Alpha = _Color.a;
			o.Emission = _Emission.rgb * _eIntensity;
			//o.Emission = _Emission.rgb;
			o.Normal = _Normal;
			//o.Alpha = _Alpha;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
