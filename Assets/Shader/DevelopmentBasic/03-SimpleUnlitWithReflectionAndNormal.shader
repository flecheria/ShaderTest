// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Flecheria/Development/03-SimpleUnlitWithReflectionAndNormal"
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
				float2 uv : TEXCOORD0; // texture coordinate
				float3 normal : NORMAL; // vertex normal
			};

			// vertex shader outputs ("vertex to fragment")
			struct v2f
			{
				float4 pos : SV_POSITION; // clip space position
				// we'll output world space reflection as one of regular ("texcoord") interpolators
				half3 worldPos : TEXCOORD0;
				// we'll output vertex normal as one of regular ("texcoord") interpolators
				half3 worldNormal : TEXCOORD1;
			};

			// vertex shader
			v2f vert(appdata v)
			{
				v2f o;

				// transform position to clip space
				// (multiply with model*view*projection matrix)
				o.pos = UnityObjectToClipPos(v.vertex);

				// compute world space position of the vertex
				float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

				// UnityCG.cginc file contains function to transform
				// normal from object to world space, use that
				o.worldNormal = UnityObjectToWorldNormal(v.normal);

				return o;
			}

			// pixel shader; returns low precision ("fixed4" type)
			// color ("SV_Target" semantic)
			fixed4 frag(v2f i) : SV_Target
			{
				// compute view direction and reflection vector
				// per-pixel here
				half3 worldViewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
				half3 worldRefl = reflect(-worldViewDir, i.worldNormal);

				// sample the default reflection cubemap, using the reflection vector
				half4 skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, worldRefl);
				// decode cubemap data into actual color
				half3 skyColor = DecodeHDR(skyData, unity_SpecCube0_HDR);

				// output it!
				fixed4 c = 0;
				c.rgb = skyColor;

				return c;
			}
            ENDCG
        }
    }
}
