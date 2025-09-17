varying vec2 vUv;

attribute vec3 aPosition;
attribute float aIndex;
attribute vec4 aTextureCoords;

uniform float uCurrentPage;
uniform float uPageThickness;
uniform float uPageWidth;
uniform float uMeshCount;
uniform float uTime;
uniform float uProgress;
uniform float uSplitProgress;

varying vec4 vTextureCoords;
varying float vIndex;


mat3 getYrotationMatrix(float angle)
{
    return mat3(
        cos(angle), 0.0, sin(angle),
        0.0, 1.0, 0.0,
        -sin(angle), 0.0, cos(angle)
    );
}

float remap(float value, float originMin, float originMax, float destinationMin, float destinationMax)
{
    return destinationMin + (value - originMin) * (destinationMax - destinationMin) / (originMax - originMin);
}

void main()
{     
    
    float PI = 3.14159265359;

    // Define the rotation center
    vec3 rotationCenter = vec3(-uPageWidth*0.5, 0.0, 0.0);
    
    // Translate position to make rotation center the origin
    vec3 translatedPosition = position - rotationCenter;    
    
    // Apply rotation around the new origin


    float rotationAcclerationProgress = clamp(remap(uProgress,0.,0.3,0.0,1.0),0.,1.);
    //float rotationAcclerationProgress = clamp(uProgress,0.,0.5)*2.;

    
    float delayBeforeStart = (aIndex / uMeshCount);
    float localRotAccelerationProgress = clamp((rotationAcclerationProgress - delayBeforeStart), 0.0, 1.0);

    float angle = -(position.x*0.2*smoothstep(0.,0.3,rotationAcclerationProgress) - rotationAcclerationProgress*2.*PI - localRotAccelerationProgress*2.*PI);


    float fullSpeedRotationAngle = clamp(remap(uProgress,0.3,0.7,0.0,1.0),0.,1.);
    angle += fullSpeedRotationAngle*4.2*PI;    

    float stackingAngle = clamp(remap(uProgress,0.7,1.,0.0,1.0),0.,1.);
    angle += position.x*0.2*stackingAngle + (1.-localRotAccelerationProgress)*2.*PI*stackingAngle + PI*1.4*stackingAngle;


    translatedPosition.z += (uMeshCount-aIndex) * uPageThickness*smoothstep(0.7,1.,stackingAngle); // Apply stacking effect along Z-axis

    //aIndex goes from 0 to uMeshCount-1
    //I need an index that goes from -uMeshCount*0.5 to uMeshCount*0.5
    //float centeredIndex = aIndex - (uMeshCount-1.)*0.5;
    
    translatedPosition.z += uSplitProgress*( - (aIndex - (uMeshCount-1.)*0.5));

    vec3 rotatedPosition = getYrotationMatrix(angle) * translatedPosition;        

    rotatedPosition.z+=uSplitProgress;
    rotatedPosition.y+=uSplitProgress*0.5;
    
    
    // Translate back to original coordinate system
    rotatedPosition += rotationCenter;
    rotatedPosition.x += uPageWidth*0.5; // Adjust X position to align pages correctly    
    
    // Apply Z-axis translation

    vec3 newPosition = rotatedPosition ;        

    vec4 modelPosition = modelMatrix * instanceMatrix * vec4(newPosition, 1.0);    

    vec4 viewPosition = viewMatrix * modelPosition;
    vec4 projectedPosition = projectionMatrix * viewPosition;
    gl_Position = projectedPosition;    

    vUv = uv;    
    vTextureCoords=aTextureCoords;
    vIndex=aIndex;
}