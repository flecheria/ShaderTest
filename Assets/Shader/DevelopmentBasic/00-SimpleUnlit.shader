// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Flecheria/Development/00-SimpleUnlit"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

			// vertex shader inputs
			struct appdata
			{
				float4 vertex : POSITION; // vertex position
				float2 uv : TEXCOORD0; // texture coordinate
			};

			// vertex shader outputs ("vertex to fragment")
			struct v2f
			{
				float4 pos : SV_POSITION; // clip space position
				float2 uv : TEXCOORD0; // texture coordinate
			};

			// vertex shader
			v2f vert(appdata v)
			{
				v2f o;

				// transform position to clip space
				// (multiply with model*view*projection matrix)
				o.pos = UnityObjectToClipPos(v.vertex);

				// just pass the texture coordinate
				o.uv = v.uv;

				return o;
			}

			// texture we will sample
			sampler2D _MainTex;

			// pixel shader; returns low precision ("fixed4" type)
			// color ("SV_Target" semantic)
			fixed4 frag(v2f i) : SV_Target
			{
				// sample texture and return it
				fixed4 col = tex2D(_MainTex, i.uv);
				return col;
			}
            ENDCG
        }
    }
}
