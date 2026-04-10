// Made with Amplify Shader Editor v1.9.6.3
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Lisa/pulse"
{
	Properties
	{
		_pulse("pulse", 2D) = "white" {}
		_pulsespeed("pulse speed", Float) = 1
		_Pulsecolour("Pulse colour", Color) = (1,1,1,0)
		_Cablecolour("Cable colour", Color) = (0,0,0,0)
		_Noisescale("Noise scale", Float) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _Cablecolour;
		uniform float4 _Pulsecolour;
		uniform sampler2D _pulse;
		uniform float _pulsespeed;
		uniform float _Noisescale;
		uniform float _Smoothness;


		inline float noise_randomValue (float2 uv) { return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453); }

		inline float noise_interpolate (float a, float b, float t) { return (1.0-t)*a + (t*b); }

		inline float valueNoise (float2 uv)
		{
			float2 i = floor(uv);
			float2 f = frac( uv );
			f = f* f * (3.0 - 2.0 * f);
			uv = abs( frac(uv) - 0.5);
			float2 c0 = i + float2( 0.0, 0.0 );
			float2 c1 = i + float2( 1.0, 0.0 );
			float2 c2 = i + float2( 0.0, 1.0 );
			float2 c3 = i + float2( 1.0, 1.0 );
			float r0 = noise_randomValue( c0 );
			float r1 = noise_randomValue( c1 );
			float r2 = noise_randomValue( c2 );
			float r3 = noise_randomValue( c3 );
			float bottomOfGrid = noise_interpolate( r0, r1, f.x );
			float topOfGrid = noise_interpolate( r2, r3, f.x );
			float t = noise_interpolate( bottomOfGrid, topOfGrid, f.y );
			return t;
		}


		float SimpleNoise(float2 UV)
		{
			float t = 0.0;
			float freq = pow( 2.0, float( 0 ) );
			float amp = pow( 0.5, float( 3 - 0 ) );
			t += valueNoise( UV/freq )*amp;
			freq = pow(2.0, float(1));
			amp = pow(0.5, float(3-1));
			t += valueNoise( UV/freq )*amp;
			freq = pow(2.0, float(2));
			amp = pow(0.5, float(3-2));
			t += valueNoise( UV/freq )*amp;
			return t;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Albedo = _Cablecolour.rgb;
			float2 temp_cast_0 = (_pulsespeed).xx;
			float2 panner2 = ( 1.0 * _Time.y * temp_cast_0 + i.uv_texcoord);
			o.Emission = ( _Pulsecolour.rgb * tex2D( _pulse, panner2 ).rgb );
			float simpleNoise9 = SimpleNoise( i.uv_texcoord*_Noisescale );
			o.Smoothness = ( simpleNoise9 * _Smoothness );
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19603
Node;AmplifyShaderEditor.RangedFloatNode;4;-590,-122.5;Inherit;False;Property;_pulsespeed;pulse speed;1;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-597,123.5;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;2;-310,-198.5;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-425.1665,338.2305;Inherit;False;Property;_Noisescale;Noise scale;4;0;Create;True;0;0;0;False;0;False;0;13.86;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;5;-35,-415.5;Inherit;False;Property;_Pulsecolour;Pulse colour;2;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,0.1967072,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;1;-66,-202.5;Inherit;True;Property;_pulse;pulse;0;0;Create;True;0;0;0;False;0;False;-1;f549d0dc336084142bc821008fdc186d;f549d0dc336084142bc821008fdc186d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.NoiseGeneratorNode;9;-168.1665,252.2305;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;74.8335,362.2305;Inherit;False;Property;_Smoothness;Smoothness;5;0;Create;True;0;0;0;False;0;False;0;0.354;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;279.8335,-336.7695;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;8;2.833496,5.230469;Inherit;False;Property;_Cablecolour;Cable colour;3;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.2830188,0.007986046,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;373.8335,249.2305;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;629,1;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Lisa/pulse;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;0;3;0
WireConnection;2;2;4;0
WireConnection;1;1;2;0
WireConnection;9;0;3;0
WireConnection;9;1;10;0
WireConnection;6;0;5;5
WireConnection;6;1;1;5
WireConnection;11;0;9;0
WireConnection;11;1;12;0
WireConnection;0;0;8;5
WireConnection;0;2;6;0
WireConnection;0;4;11;0
ASEEND*/
//CHKSM=AD8B5AC4F8F6EFCC886EB7934EE96B24C62874BF