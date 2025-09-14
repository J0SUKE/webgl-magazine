varying vec2 vUv;
uniform vec2 uMediaDimensions;
uniform float uProgress;
uniform float uGridBase;
uniform float uColor;

vec2 coverUvs(vec2 imageRes,vec2 containerRes,vec2 vUv)
{
    float imageAspectX = imageRes.x/imageRes.y;
    float imageAspectY = imageRes.y/imageRes.x;
    
    float containerAspectX = containerRes.x/containerRes.y;
    float containerAspectY = containerRes.y/containerRes.x;

    vec2 ratio = vec2(
        min(containerAspectX / imageAspectX, 1.0),
        min(containerAspectY / imageAspectY, 1.0)
    );

    vec2 newUvs = vec2(
        vUv.x * ratio.x + (1.0 - ratio.x) * 0.5,
        vUv.y * ratio.y + (1.0 - ratio.y) * 0.5
    );

    return newUvs;
}

void main()
{            
    
    float gridBase = uGridBase;    
    
    vec2 grid = vec2(
        floor(max(uMediaDimensions.x/uMediaDimensions.y,1.) * gridBase),
        floor(max(uMediaDimensions.y/uMediaDimensions.x,1.) * gridBase)
    );

    vec2 gridUvs = vec2(
        floor(vUv.x * grid.x) / grid.x,
        floor(vUv.y * grid.y) / grid.y
    );

    vec2 squareGridUvs = coverUvs(vec2(1.),uMediaDimensions,gridUvs);
    vec2 squareUvs = coverUvs(vec2(1.),uMediaDimensions,vUv);

    float progress = uProgress;

    float localProgress = clamp(0.,exp(1.) * progress + (1.-exp(gridUvs.y)),1.);

    float finalProgress = localProgress * 0.71;

    //0.71 is the radius of circle covering a 1x1 square at 100%

    
    float gridDist = max(grid.x, grid.y);

    vec2 aspect = vec2(
        min(uMediaDimensions.x/uMediaDimensions.y,1.),
        min(uMediaDimensions.y/uMediaDimensions.x,1.)
    );

    float dist = 1.-step(finalProgress/gridDist,distance(squareUvs, squareGridUvs  + vec2(0.5*aspect.x/grid.x, 0.5*aspect.y/grid.y)));

        
    
    vec4 final = vec4(vec3(max(uColor,1.-dist)),dist);

    gl_FragColor = final;
}