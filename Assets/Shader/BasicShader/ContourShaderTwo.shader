// https://www.youtube.com/watch?v=AK8oV4BzrW4
// https://answers.unity.com/questions/1246324/get-color-coordinate-from-the-texture-and-convert.html
// https://en.wikibooks.org/wiki/Cg_Programming/Unity/Shading_in_World_Space
// https://answers.unity.com/questions/300106/shader-height-lines.html
// https://forum.unity.com/threads/using-local-height-to-determine-color-vertex-fragment-shader.505312/
// https://stackoverflow.com/questions/30891763/how-to-create-latitudinal-horizontal-contour-lines-in-glsl
// http://blog.ruofeidu.com/simplest-fatest-glsl-edge-detection-using-fwidth/

Shader "Flecheria/Effect/ContourShaderTwo"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Step("Step", Float) = 50.0
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
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

			// variables
            sampler2D _MainTex;
            float4 _MainTex_ST;
			float _Step;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				//fixed4 col = tex2D(_MainTex, i.uv);
				float f = frac(i.vertex.y * _Step);
				float df = abs(ddx(i.vertex.y * _Step)) + abs(ddy(i.vertex.y * _Step));

				float g = smoothstep(df * 1.0, df * 2.0, f);
				float value = g;
				
				// version 1
				//float value = pow((float)((int)i.vertex.y % (int)_Step) / _Step, 2);
                
				return fixed4(value, value, value, 1.0);
            }
            ENDCG
        }
    }
}
