﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'
// http://www.shaderslab.com/demo-50---grayscale-depending-zbuffer.html

Shader "Flecheria/Render/ZBufferShader"
{
    SubShader
    {
        Tags { "RenderType" = "Opaque"}

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

			struct v2f
			{
				float4 pos : SV_POSITION;
				float4 screenUV : TEXCOORD1;
			};

            v2f vert (appdata_base v)
            {
                v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.screenUV = ComputeScreenPos(o.pos);

                return o;
			};

            sampler2D _CameraDepthTexture;

            fixed4 frag (v2f i) : SV_Target
            {
				float2 uv = i.screenUV.xy / i.screenUV.w;
				float depth = 1 - Linear01Depth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, uv));

				return fixed4(depth, depth, depth, 1);
            }
            ENDCG
        }
    }
}
