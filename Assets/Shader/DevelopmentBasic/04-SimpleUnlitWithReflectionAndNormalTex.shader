// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Flecheria/Development/04-SimpleUnlitWithReflectionAndNormalTex"
{
    Properties
    {
		// normal map texture on the material,
		// default to dummy "flat surface" normalmap
		_BumpMap("Normal Map", 2D) = "bump" {}
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
				float4 tangent : TANGENT;
			};

			// vertex shader outputs ("vertex to fragment")
			struct v2f
			{
				float4 pos : SV_POSITION; // clip space position
				float2 uv : TEXCOORD0;

				// we'll output world space reflection as one of regular ("texcoord") interpolators
				half3 worldPos : TEXCOORD1;

				// these three vectors will hold a 3x3 rotation matrix
				// that transforms from tangent to world space
				half3 tspace0 : TEXCOORD2; // tangent.x, bitangent.x, normal.x
				half3 tspace1 : TEXCOORD3; // tangent.y, bitangent.y, normal.y
				half3 tspace2 : TEXCOORD4; // tangent.z, bitangent.z, normal.z
			};

			// vertex shader
			v2f vert(appdata v)
			{
				v2f o;

				// transform position to clip space
				// (multiply with model*view*projection matrix)
				o.pos = UnityObjectToClipPos(v.vertex);

				o.uv = v.uv;

				// compute world space position of the vertex
				float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

				// UnityCG.cginc file contains function to transform
				// normal from object to world space, use that
				half3 wNormal = UnityObjectToWorldNormal(v.normal);

				half3 wTangent = UnityObjectToWorldDir(v.tangent.xyz);

				// compute bitangent from cross product of normal and tangent
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 wBitangent = cross(wNormal, wTangent) * tangentSign;
				// output the tangent space matrix
				o.tspace0 = half3(wTangent.x, wBitangent.x, wNormal.x);
				o.tspace1 = half3(wTangent.y, wBitangent.y, wNormal.y);
				o.tspace2 = half3(wTangent.z, wBitangent.z, wNormal.z);

				return o;
			}

			// normal map texture from shader properties
			sampler2D _BumpMap;

			// pixel shader; returns low precision ("fixed4" type)
			// color ("SV_Target" semantic)
			fixed4 frag(v2f i) : SV_Target
			{
				// sample the normal map, and decode from the Unity encoding
				half3 tnormal = UnpackNormal(tex2D(_BumpMap, i.uv));
				// transform normal from tangent to world space
				half3 worldNormal;
				worldNormal.x = dot(i.tspace0, tnormal);
				worldNormal.y = dot(i.tspace1, tnormal);
				worldNormal.z = dot(i.tspace2, tnormal);
				
				// compute view direction and reflection vector
				// per-pixel here
				half3 worldViewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
				half3 worldRefl = reflect(-worldViewDir, worldNormal);

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
