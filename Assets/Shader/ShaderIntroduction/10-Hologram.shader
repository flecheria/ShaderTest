// look at shader 11-RimEffect to get the full solid effect
Shader "Flecheria/ShaderIntroduction/10-Hologram" 
{
    Properties {
      _RimColor ("Rim Color", Color) = (0,0.5,0.5,0.0)
      _RimPower ("Rim Power", Range(0.5,8.0)) = 3.0
    }
    SubShader 
	{
		Tags{"Queue" = "Transparent"}

		// this is another pass before the main pass
		Pass {
			ZWrite On
			ColorMask 0 // off for debug
			//ColorMask RGB // turn on for debug
		}

		CGPROGRAM
		
		// from here start the main pass
		#pragma surface surf Lambert alpha:fade
		struct Input {
			float3 viewDir;
		};

		float4 _RimColor;
		float _RimPower;
      
		void surf (Input IN, inout SurfaceOutput o) {
			half rim = 1.0 - saturate(dot (normalize(IN.viewDir), o.Normal));
			o.Emission = _RimColor.rgb * pow (rim, _RimPower) * 10;
			o.Alpha = pow (rim, _RimPower);
		}
		// main pass end here
		ENDCG
	} 
	Fallback "Diffuse"
  }