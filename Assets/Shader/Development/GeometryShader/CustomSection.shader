Shader "Flecheria/Geometry/CustomSection"
{
    Properties
    {
		_Color1("Outside color", Color) = (1.0, 1.0, 1.0, 1.0)
		_Color2("Section color", Color) = (1.0, 0.0, 0.0, 1.0)
		_EdgeWidth("Edge width", Range(0.9, 0.1)) = 0.9
		_Val("Height value", Range(-1, 10)) = 2
    }
    SubShader
	{
		Tags { "Queue" = "Geometry" }
		
		// pass 1
		CGPROGRAM
		#pragma surface surf Standard

		struct Input {
			float3 worldPos;
		};

		fixed _Color1;
		float _Val;

		void surf(Input IN, inout SurfaceOutputStandard o) {
			if (IN.worldPos.y > _Val)
				discard;

			o.Albedo = _Color1;
		}
		ENDCG

		// Pass 2
		Pass {
			Cull Front

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct v2f {
				float4 pos : SV_POSITION;
				float4 worldPos : TEXCOORD0;
			};

			v2f vert(appdata_base v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				return o;
			};

			fixed4 _Color2;
			float _Val;
			
			fixed4 frag(v2f i) : SV_Target {
                if(i.worldPos.y > _Val)
                    discard;
 
                return _Color2;
            }
			ENDCG
		}

		// Pass 3
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct v2f {
				float4 pos : SV_POSITION;
				float4 worldPos : TEXCOORD0;
			};

			float _EdgeWidth;
			fixed4 _Color2;
			float _Val;

			v2f vert(appdata_base v) {
				v2f o;
				v.vertex.xyz *= _EdgeWidth;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				return o;
			};

			fixed4 frag(v2f i) : SV_Target {
				if (i.worldPos.y > _Val)
					discard;

				return _Color2;
			}
			
			ENDCG
		}

		// Pass 4
		Cull Front

		CGPROGRAM
		#pragma surface surf Standard vertex:vert

		struct Input {
			float3 worldPos;
		};

		float _EdgeWidth;
		fixed4 _Color1;
		float _Val;

		void vert(inout appdata_base v) {
			v.vertex.xyz *= _EdgeWidth;
		}

		void surf(Input IN, inout SurfaceOutputStandard o)
		{
			if (IN.worldPos.y > _Val)
				discard;

			o.Albedo = _Color1;
		}
		ENDCG
	}
}
