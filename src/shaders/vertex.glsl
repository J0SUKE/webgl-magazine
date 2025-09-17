varying vec2 vUv;

attribute vec3 aPosition;
attribute float aIndex;
uniform float uCurrentPage;
uniform float uPageThickness;
uniform float uPageWidth;
uniform float uMeshCount;
uniform float uTime;
uniform float uRotAcceleration;
uniform float uInfinitRotation;

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


    
    float delayBeforeStart = (aIndex / uMeshCount);
    float effectiveProgress = clamp((uRotAcceleration - delayBeforeStart), 0.0, 1.0);

    float angle = position.x*0.2*uRotAcceleration - uRotAcceleration*2.*PI - effectiveProgress*2.*PI;



    vec3 rotatedPosition = getYrotationMatrix(angle) * translatedPosition;
    
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
}