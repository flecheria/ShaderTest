Shader "Flecheria/Unlit/TextureDistortion"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_OffsetX ("OffsetX", Range(0.0, 1.0)) = 0.5
		_OffsetY ("OffsetY", Range(0.0, 1.0)) = 0.5
		_DistortFactor ("DistortFactor", Range(0.0, 50.0)) = 20.0
		_DistortScale ("DistortScale", Range(0.0, 1.0)) = 0.1
		_DistortFresnel ("DistortFresnel", Range(0.0, 0.9)) = 0.1

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			float _OffsetX;
			float _OffsetY;
			float _DistortFactor;
			float _DistortScale;
			float _DistortFresnel;

            v2f vert (appdata v)
            {
                v2f o;

				// vertex modification
				//v.vertex.y = sin(v.vertex.x + _Time.y);

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
			{
				// set the uv
				float2 uv = i.uv;

				// move the backgorund
				//uv = uv - 0.5;
				uv.x = uv.x - _OffsetX;
				uv.y = uv.y - _OffsetY;

				// set a position of the circle
				float a = _Time.y;
				float2 p = float2(sin(a), cos(a)) * 0.4;
				float2 distort = uv - p;
				float d = length(distort);

				// make a circle
				float fresnel = _DistortScale - (_DistortScale * _DistortFresnel);
				float m = smoothstep(_DistortScale, fresnel, d);
				//float4 distortVisualization = float4(m * distort.x, m * distort.y, 0, 0) * _DistortScale;
				distort = distort * _DistortFactor * m;

				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv + distort);

                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                
				return col;
            }
            ENDCG
        }
    }
}
