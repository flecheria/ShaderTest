// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Flecheria/Development/01-SimpleUnlitWithNormal"
{
    Properties
    {
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
				float3 normal : NORMAL; 
			};

			// vertex shader outputs ("vertex to fragment")
			struct v2f
			{
				float4 pos : SV_POSITION; // clip space position
				// we'll output world space normal as one of regular ("texcoord") interpolators
				half3 worldNormal : TEXCOORD0;
			};

			// vertex shader
			v2f vert(appdata v)
			{
				v2f o;

				// transform position to clip space
				// (multiply with model*view*projection matrix)
				o.pos = UnityObjectToClipPos(v.vertex);

				// UnityCG.cginc file contains function to transform
				// normal from object to world space, use that
				o.worldNormal = UnityObjectToWorldNormal(v.normal);

				return o;
			}

			// pixel shader; returns low precision ("fixed4" type)
			// color ("SV_Target" semantic)
			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 c = 0;
				// normal is a 3D vector with xyz components; in -1..1
				// range. To display it as color, bring the range into 0..1
				// and put into red, green, blue components
				c.rgb = i.worldNormal * 0.5 + 0.5;

				return c;
			}
            ENDCG
        }
    }
}
