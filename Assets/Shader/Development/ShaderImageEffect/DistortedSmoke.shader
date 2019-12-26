//http://glslsandbox.com/e#37255.0
Shader "Flecheria/ShaderImageEffect/DistortedSmoke"
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

			half random(half2 pos)
			{
				return frac(sin(dot(pos.xy, half2(12.345, 23.456))) * 1.2345);
			}

			half noise(half2 pos)
			{
				half2 i = floor(pos);
				half2 f = frac(pos);
				half a = random(i + half2(0.0, 0.0));
				half b = random(i + half2(1.0, 0.0));
				half c = random(i + half2(0.0, 1.0));
				half d = random(i + half2(1.0, 1.0));
				half2 u = f * f * (3.0 - 2.0 * f);
				return lerp(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
			}

			half fbm(half2 pos)
			{
				half v = 0.0;
				half a = 0.58;

				half2x2 rot = half2x2(cos(0.5), sin(0.5), -sin(0.5), cos(0.5));

				for (int i = 0; i < 10; i++)
				{
					v += a * noise(pos);
					pos = mul(rot, pos) * 2;
					a *= 0.5;
				}
				return v;
			}

			fixed4 frag(v2f_img i) : SV_Target
			{
				half2 resolution = half2(1, 1);
				half2 p = (i.uv * 2.0 - resolution.xy) / min(resolution.x, resolution.y);

				half3 color = half3(0,0,0);
				half time = _Time.y * 30;

				half t = 0.0, d;
				half time2 = time / 2;
				half2 q = half2(0, 0);
				q.x = fbm(p + half2(1.0,1.0) + 0.01 * time2);
				q.y = fbm(p + half2(1.0,1.0));
				half2 r = half2(0, 0);

				r.x = fbm(p + q + half2(1.7, 9.2) + 0.15 * time2);
				r.y = fbm(p + q + half2(8.3, 2.8) + 0.126 * time2);

				half f = fbm(p + r);

				color = lerp(
					color,
					half3(0.666667, 1, 1),
					clamp(length(r.x), 0.0, 1.0)
				);

				color = (f *f * f + 0.6 * f * f + 0.5 * f) * color;

				return half4(color, 1.0);
			}
			ENDCG
		}
	}
}
