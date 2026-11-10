#version 460

layout(set = 3, binding = 0, std140) uniform type_Constants {
  float mouseX;
  float mouseY;
  float time;
  float color_scale;
} Constants;

layout(set = 2, binding = 0) uniform texture2D u_texture;
layout(set = 2, binding = 0) uniform sampler u_sampler;

layout(location = 0) in vec4 in_var_COLOR0;
layout(location = 1) in vec2 in_var_TEXCOORD0;
layout(location = 0) out vec4 outColor;// This determines the final pixel color

void main()
{
    vec4 textureColor = texture(sampler2D(u_texture, u_sampler),in_var_TEXCOORD0);
    float constant = Constants.color_scale;
    if(textureColor.r <= 0.01 && textureColor.g <= 0.01 && textureColor.b <= 0.01){
      discard;
    }
    outColor = vec4(textureColor.rgb * constant,1.0) ;
}


