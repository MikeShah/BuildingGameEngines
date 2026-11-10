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
    
    vec2 mousePos = vec2(Constants.mouseX,Constants.mouseY);
    vec2 fragPos  = vec2(gl_FragCoord.x,gl_FragCoord.y);
    if(distance(mousePos, fragPos) < 100.0f){
      outColor = mix(vec4(0,0.25,.75,1),    textureColor,   0.5);
    }else{
      outColor = vec4(textureColor.rgb * constant,1.0) ;
    }
}


