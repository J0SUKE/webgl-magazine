varying vec2 vUv;

attribute vec3 aPosition;
attribute float aIndex;
uniform float uCurrentPage;
uniform float uPageThickness;
uniform float uPageWidth;

mat3 getYrotationMatrix(float angle)
{
    return mat3(
        cos(angle), 0.0, sin(angle),
        0.0, 1.0, 0.0,
        -sin(angle), 0.0, cos(angle)
    );
}


void main()
{     
    
    float PI = 3.14159265359;

    //the page is turned if uCurrentPage >= aIndex-1 =====> uCurrentPage - aIndex >= 1
    float pageTurned = step(1.,uCurrentPage - aIndex);

    // Define the rotation center
    vec3 rotationCenter = vec3(-uPageWidth*0.5*pageTurned, 0.0, 0.0);
    
    // Translate position to make rotation center the origin
    vec3 translatedPosition = position - rotationCenter;    
    
    // Apply rotation around the new origin
    vec3 rotatedPosition = getYrotationMatrix(PI*pageTurned) * translatedPosition;
    
    // Translate back to original coordinate system
    rotatedPosition += rotationCenter;
    
    // Apply Z-axis translation

    rotatedPosition.z += -uPageThickness*((floor(uCurrentPage)-aIndex)*2. - 1.)*pageTurned;

    vec3 newPosition = rotatedPosition + aPosition;

    vec4 modelPosition = modelMatrix * instanceMatrix * vec4(newPosition, 1.0);    

    vec4 viewPosition = viewMatrix * modelPosition;
    vec4 projectedPosition = projectionMatrix * viewPosition;
    gl_Position = projectedPosition;    

    vUv = uv;    
}