#ifdef GL_ES
precision highp float;
#endif

// Type of shader expected by Processing
#define PROCESSING_COLOR_SHADER

// Processing specific input
uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;

uniform sampler2D iChannel0;          // input channel. XX = 2D/Cube

// Layer between Processing and Shadertoy uniforms
vec3 iResolution = vec3(resolution,0.0);
float iGlobalTime = time;
vec4 iMouse = vec4(mouse,0.0,0.0); // zw would normally be the click status




// Created by inigo quilez - iq/2013
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // create pixel coordinates
	vec2 uv = fragCoord.xy / iResolution.xy;

	// first texture row is frequency data
	float fft  = texture2D( iChannel0, vec2(uv.x,0.25) ).x; 
	
    // second texture row is the sound wave
	float wave = texture2D( iChannel0, vec2(uv.x,0.75) ).x;
	
	// convert frequency to colors
	vec3 col = vec3( fft, 4.0*fft*(1.0-fft), 1.0-fft ) * fft;

    // add wave form on top	
	col += 1.0 -  smoothstep( 0.0, 0.15, abs(wave - uv.y) );
	
	// output final color
	fragColor = vec4(col,1.0);
}

     
// mainImage wrapper
void main(void)
{
    vec2 p = gl_FragCoord.xy;
    vec4 mycol = vec4(0.0,0.0,0.0,0.0);
    mainImage(mycol, p);
    gl_FragColor = mycol;
}