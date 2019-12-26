Shader "Flecheria/ShaderIntroduction/12-BlendTest"
{
	Properties
	{
		_DiffuseTex("Diffuse Texture", 2D) = "black" {}
	}
	SubShader
	{
		Tags 
		{
			"Queue" = "Transparent"
		}

		Blend One One
		//Blend SrcAlpha OneMinusSrcAlpha
		//Blend DstColor Zero

		Pass
		{
			SetTexture [_DiffuseTex] { combine texture }
		}
	}
	FallBack "Diffuse"
}
