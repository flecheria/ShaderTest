Shader "Flecheria/SurfaceShader/SimpleCrossingSinusoid"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows vertex:vert

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0
		#define PI = 3.1415926535

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

		float sinusoid(float x, float y, float factor)
		{
			return (sin(_Time.y + x * factor) + cos(_Time.y + y * factor));
		}

		void vert(inout appdata_full v) {
			v.vertex.xyz += v.normal * sinusoid(v.vertex.x, v.vertex.z, 0.5);// (sin(time + v.vertex.x) + cos(time + v.vertex.z));
		}

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
        // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            //fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;

			fixed2 resolution = _ScreenParams;
			fixed2 position = (IN.uv_MainTex * resolution / resolution.xy);
			float time = _Time.y;
			fixed color = 0.0;
			color = sinusoid(position.x, position.y, 5.0);
			//color = clamp(color, 0.0, 1.0);

            //o.Albedo = c.rgb;
			o.Albedo = fixed3(color, color, color);
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = 1.0;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
