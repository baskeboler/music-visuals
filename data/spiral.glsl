#ifdef GL_ES
precision highp float;
#endif

// Type of shader expected by Processing
#define PROCESSING_COLOR_SHADER

// Processing specific input
uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;


// Layer between Processing and Shadertoy uniforms
vec3 iResolution = vec3(resolution,0.0);
float iGlobalTime = time;
vec4 iMouse = vec4(mouse,0.0,0.0); // zw would normally be the click status

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / iResolution.xy / .5 - 1.;
    uv.x *= iResolution.x / iResolution.y;
    
    // make a tube
    float f = 1. / length(uv);
    
    // add the angle
    f += atan(uv.x, uv.y) / acos(0.);
    
    // let's roll
    f -= iGlobalTime;
    
    // make it black and white
    f = floor(fract(f) * 2.);
    
    // add the darkness to the end of the tunnel
    f *= sin(length(uv) - .1);
	
    fragColor = vec4(f, f, f, 1.0);
}


// mainImage wrapper
void main(void)
{
    vec2 p = gl_FragCoord.xy;
    vec4 mycol = vec4(0.0,0.0,0.0,0.0);
    mainImage(mycol, p);
    gl_FragColor = mycol;
}