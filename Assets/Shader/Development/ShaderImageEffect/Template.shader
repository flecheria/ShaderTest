Shader "Flecheria/ShaderImageEffect/Template"
{
	Properties
	{
	}
	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag

			#include "UnityCG.cginc"

			fixed4 frag(v2f_img i) : SV_Target
			{
				fixed2 resolution = _ScreenParams;
				fixed2 position = (i.uv * resolution.x) / resolution.xy;

				float time = _Time.y * 30;
				fixed3 color = 0.0;

				color = float3(position.x, position.y, abs(sin(time)));

				return fixed4(color, 1.0);
			}
			ENDCG
		}
	}
}
