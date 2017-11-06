// Per-pixel color data passed through the pixel shader.
struct PixelShaderInput
{
	float4 pos : SV_POSITION;
	float3 color : COLOR0;
	float3 normWorld : NORMAL;
	float3 normView : NORMAL2;

	float3 Lightnorm : NORMAL1;
	float3 Lightcolor : COLOR1;
	float3 Lightpos : POSITION1;
	float3 Lighttype : POSITION2;
	
};

// A pass-through function for the (interpolated) color data.
float4 main(PixelShaderInput input) : SV_TARGET
{
	//This is directional Light
	 if (input.Lighttype.x >= 0.0f && input.Lighttype.x < 1) {
		 float lightRatio = saturate(dot(-input.Lightnorm, input.normWorld));
		 input.color = lightRatio * input.Lightcolor * input.color;
		}
//point light
if (input.Lighttype.x >= 1.0f && input.Lighttype.x < 2) {
	float3 pos = float3(input.pos.xyz);
	float3 lightDir = normalize(input.Lightpos - pos);
	float lightRatio = saturate(dot(lightDir, input.normWorld));
	input.color = lightRatio * input.Lightcolor * input.color;
}
//Spot light
if (input.Lighttype.x >= 2.0f && input.Lighttype.x < 3) {
	float3 pos = float3(input.pos.xyz);
	float3 lightDir = normalize(input.Lightpos - pos);
	float spotfactor = 0.0f;
	float lightRatio = saturate(dot(-lightDir, input.Lightnorm));
	//0.5 is the cone ratio
	if (lightRatio > 0.5) {
		spotfactor = 1.0f;
	}

	input.color = lightRatio * spotfactor * input.color * input.Lightcolor;
}
	

	return float4(input.color, 1.0f);
}
