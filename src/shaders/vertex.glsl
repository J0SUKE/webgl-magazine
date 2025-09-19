varying vec2 vUv;

attribute vec3 aPosition;
attribute float aIndex;
attribute vec4 aTextureCoords;

uniform float uCurrentPage;
uniform float uPageThickness;
uniform float uPageWidth;
uniform float uPageHeight;
uniform float uMeshCount;
uniform float uTime;
uniform float uProgress;
uniform float uSplitProgress;
uniform float uPageSpacing;

uniform float uScrollY;
uniform float uMaxX;
uniform float uSpeedY;

varying vec4 vTextureCoords;
varying float vIndex;
varying float vRotationProgress;
varying vec3 vPosition;
varying float vAngle;



mat3 getYrotationMatrix(float angle)
{
    return mat3(
        cos(angle), 0.0, sin(angle),
        0.0, 1.0, 0.0,
        -sin(angle), 0.0, cos(angle)
    );
}

mat3 getXrotationMatrix(float angle)
{
    return mat3(
        1.0, 0.0, 0.0,
        0.0, cos(angle), -sin(angle),
        0.0, sin(angle), cos(angle)
    );
}

//linear smoothstep
float remap(float value, float originMin, float originMax)
{
    return clamp((value - originMin) / (originMax - originMin),0.,1.);
}

float getXwave(float x)
{
    return sin(x*2.) * 0.4;
}

void main()
{     
    
    float PI = 3.14159265359;

    //vec3 initialXRotatedPosition = getXrotationMatrix(-PI*0.2)*position;


    // Define the rotation center
    vec3 rotationCenter = vec3(-uPageWidth*0.5, 0.0, 0.0);
    
    // Translate position to make rotation center the origin
    vec3 translatedPosition = position - rotationCenter;    
    
    // Apply rotation around the new origin


    float rotationAcclerationProgress = remap(uProgress,0.,0.3);

    //float rotationAcclerationProgress = clamp(uProgress,0.,0.5)*2.;

    
    float delayBeforeStart = (aIndex / uMeshCount);
    float localRotAccelerationProgress = clamp((rotationAcclerationProgress - delayBeforeStart), 0.0, 1.0);

    float yAngle = -(position.x*0.2*smoothstep(0.,0.3,rotationAcclerationProgress) - rotationAcclerationProgress*2.*PI - localRotAccelerationProgress*2.*PI);


    float fullSpeedRotationAngle = remap(uProgress,0.3,0.7);
    yAngle += fullSpeedRotationAngle*4.2*PI;    

    float stackingAngle = remap(uProgress,0.7,1.);
    yAngle += position.x*0.2*stackingAngle + (1.-localRotAccelerationProgress)*2.*PI*stackingAngle + PI*1.7*stackingAngle;

    vAngle=(aIndex - (uMeshCount-1.)*0.5)*smoothstep(0.8,1.,stackingAngle)*((uPageWidth-translatedPosition.x-1.)*0.005);
    translatedPosition.z+= vAngle;
    yAngle+= (aIndex - (uMeshCount-1.)*0.5)*smoothstep(0.8,1.,stackingAngle)*((-pow(translatedPosition.x,2.))*0.001);


    translatedPosition.z += (uMeshCount-aIndex) * uPageThickness*smoothstep(0.8,1.,stackingAngle); // Apply stacking effect along Z-axis

    //aIndex goes from 0 to uMeshCount-1
    //I need an index that goes from -uMeshCount*0.5 to uMeshCount*0.5
    //float centeredIndex = aIndex - (uMeshCount-1.)*0.5;

    yAngle-=uSplitProgress*PI*0.4;
    
    translatedPosition.z += uSplitProgress*uPageSpacing*( - (aIndex - (uMeshCount-1.)*0.5));    

    float baseProgress = translatedPosition.z + uScrollY;

    float xPoz = mod(baseProgress,uMaxX) - uMaxX + getXwave((position.y+uPageHeight*0.5)/uPageHeight)*clamp(uSpeedY*2.,-2.,1.3);
    
    translatedPosition.z = xPoz*floor(uSplitProgress);

    
    vec3 rotatedPosition = getYrotationMatrix(yAngle) * translatedPosition;        

    rotatedPosition.z-=uSplitProgress;
    //rotatedPosition.y+=uSplitProgress*0.5;
    
    float initialRotationProgress = remap(uProgress,0.,0.15);    


    // Translate back to original coordinate system
    rotatedPosition += rotationCenter;
    rotatedPosition.x += initialRotationProgress*uPageWidth*0.5; // Adjust X position to align pages correctly        
        

    float xAngle = -PI*0.2*initialRotationProgress;

    xAngle+=uSplitProgress*PI*0.2;

    vec3 newPosition = getXrotationMatrix(xAngle) * rotatedPosition;

    //Scroll logic
    float maxWave = 0.5;
        


    vec4 modelPosition = modelMatrix * instanceMatrix * vec4(newPosition, 1.0);    

    vec4 viewPosition = viewMatrix * modelPosition;
    vec4 projectedPosition = projectionMatrix * viewPosition;
    gl_Position = projectedPosition;    

    vUv = uv;    
    vTextureCoords=aTextureCoords;
    vIndex=aIndex;
    vRotationProgress=localRotAccelerationProgress;
    vPosition=translatedPosition;
}