varying vec2 vUv;
varying vec4 vTextureCoords;
uniform sampler2D uAtlas;


varying float vIndex;
varying float vRotationProgress;
varying vec3 vPosition;
varying float vAngle;


void main()
{            
                 
    // Get UV coordinates for this image from the uniform array
    float xStart = vTextureCoords.x;
    float xEnd = vTextureCoords.y;
    float yStart = vTextureCoords.z;
    float yEnd = vTextureCoords.w;

     vec2 atlasUV = vec2(
        mix(xStart, xEnd, vUv.x),
        mix(yStart, yEnd, 1.-vUv.y)
    );

    if(vRotationProgress==0. && vIndex!=0.)
    {
        discard;
    }
    
    // Sample the texture
    vec4 color = texture2D(uAtlas, atlasUV);
    
    
    float x = vPosition.x;
    float xOutOfRange = step(vPosition.x,0.) + (1.-step(vPosition.x,1.));
    
    //gl_FragColor = vec4(vec3(x,xOutOfRange,xOutOfRange),1.);
    gl_FragColor = color;
}