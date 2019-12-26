Shader "Flecheria/ShaderIntroduction/VF/05-DiffuseShadowVF"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        // this pass accept shadows
		Pass
        {
			Tags {
				"RenderType" = "Opaque"
				"LightMode" = "ForwardBase"
			}
			//LOD 100
			CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
			
			#pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight
            #include "UnityCG.cginc"
			//you need to include this file if you want to wark light properties
			#include "UnityLightingCommon.cginc"
			// include this to calculate shadow
			#include "Lighting.cginc"
			#include "Autolight.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
				float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
				float4 diff : COLOR0; // value for diffuse color, produced for the lighing in the calculation
                float4 pos : SV_POSITION; // this needs to be called pos because
				// TRANSFER_SHADOW(o) looking for something called pos inside o
				SHADOW_COORDS(1)
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
				// convert value from worldspace to screen space
                o.pos = UnityObjectToClipPos(v.vertex);
				// get the uv from the object
				o.uv = v.uv;
				// convert normal from the local space of the object to the world coordinates
				half3 worldNormal = UnityObjectToWorldNormal(v.normal);
				// calcolate the dot product between he normal direction on the
				// object and the light direction
				half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
				// calculate the color
				o.diff = nl * _LightColor0;
				TRANSFER_SHADOW(o);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
				fixed shadow = SHADOW_ATTENUATION(i);
				col.rgb *= i.diff * shadow;

                return col;
            }
            ENDCG
        }
		// enter the shadow Pass
		Pass
		{
			Tags {
				"LightMode" = "ShadowCaster"
			}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_shadowcaster

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
			};

			struct v2f {
				// this specify that this pass it-s only for shadow
				V2F_SHADOW_CASTER;
			};

			v2f vert(appdata v)
			{
				v2f o;
				// create shadow data
				TRANSFER_SHADOW_CASTER_NORMALOFFSET(o);
				return o;
			}

			float4 frag(v2f i) : SV_Target
			{
				// casting the shadow
				SHADOW_CASTER_FRAGMENT(i);
			}
			ENDCG
		}
    }
}
