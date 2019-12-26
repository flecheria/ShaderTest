Shader "Flecheria/VertexProgram/04-VisualizeNormal" 
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags{
			"Queue" = "Geometry"
			"RenderType" = "Opaque"
			"LightMode" = "ForwardBase"
		}

		Pass 
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma geometry geom

			#include "UnityCG.cginc"

			// variables
			float4 _Color;
			sampler2D _MainTex;

			// from vertex to geometry operation
			struct v2g
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 vertex : TEXCOORD1;
			};

			// from geometry operation to fragment
			struct g2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float light : TEXCOORD1;
			};

			// vertex program
			v2g vert(appdata_full v) 
			{
				v2g o;
				o.vertex = v.vertex;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord;
				return o;
			}

			// geometry operation
			[maxvertexcount(3)]
			void geom(triangle v2g IN[3], inout TriangleStream<g2f> triStream)
			{
				g2f o;

				// Compute the normal
				float3 vecA = IN[1].vertex - IN[0].vertex;
				float3 vecB = IN[2].vertex - IN[0].vertex;
				float3 normal = cross(vecA, vecB);
				normal = normalize(mul(normal, (float3x3) unity_WorldToObject));

				// Compute diffuse light
				float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
				o.light = max(0., dot(normal, lightDir));

				// Compute barycentric uv
				o.uv = (IN[0].uv + IN[1].uv + IN[2].uv) / 3;

				for (int i = 0; i < 3; i++)
				{
					o.pos = IN[i].pos;
					triStream.Append(o);
				}
			}

			half4 frag(g2f i) : COLOR
			{ 
				float4 col = tex2D(_MainTex, i.uv);
				col.rgb *= i.light * _Color;
				return col;
			}
			ENDCG
		}
	}
}