// https://www.videopoetics.com/tutorials/pixel-perfect-outline-shaders-unity/

Shader "Flecheria/Basic/OutlineShaderClassic"
{
    Properties
    {
		_Color("Color", Color) = (1, 1, 1, 1)
		_Glossiness("Smoothness", Range(0, 1)) = 0.5
		_Metallic("Metallic", Range(0, 1)) = 0
		_OutlineColor("Outline Color", Color) = (0, 0, 0, 1)
		_OutlineWidth("Outline Width", Range(0, 0.1)) = 0.03
    }
    SubShader
    {
		Tags { "RenderType" = "Opaque" }

		CGPROGRAM
		
		Input { float4 color : COLOR }

		half4 _Color;
		half _Glossiness;
		half _Metallic;

		void surf(Input IN, inout SufaceStandardOutput o) 
		{
			o.Albedo = _Color.rgb * IN.color.rgb;
			o.Smoothness = _Glossiness;
			o.Metallic = _Metallic;
			o.Alpha = _Color.a * IN.color.a;
		}
		ENDCG

        Pass
        {
            Cull Front

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			half _OutlineWidth;

			float4 vert(
				float4 position : POSITION,
				float3 normal : NORMAL) : SV_POSITION 
			{
				position.xyz += normal * _OutlineWidth;
				return UnityObjectToClipPos(position);
			}

			half4 _OutlineColor;

			half4 frag() : SV_TARGET
			{
				return _OutlineColor;
			}
			ENDCG
        }
    }
}
