Shader "Flecheria/ShaderIntroduction/VF/01-ColorVF"
{
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
				float4 color : COLOR;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
				o.color.r = smoothstep(o.vertex.x, -0.7, 0.7);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
				//fixed4 col = fixed4(i.vertex.x, 0, 1, 1);
				fixed4 col = i.color;
                return col;
            }
            ENDCG
        }
    }
}
