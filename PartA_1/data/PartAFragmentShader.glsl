#define PROCESSING_LIGHT_SHADER

precision mediump float;

varying vec3 normalInterp;
varying vec3 vertPos;

//set by user
uniform float specularFocus;
uniform float specularContribution;
uniform float diffuseContribution;


uniform int lightCount;
uniform vec4 lightPosition[8];

void main() {
    
    vec3 lightIntensity = vec3(0.4,0.4,0.4);
    
    float R = 0.0;
    float G = 0.0;
    float B = 0.0;
    
    for (int i = 0; i < lightCount; i++)
    {
        vec3 normal = normalize(normalInterp);
        vec3 lightDir = normalize(lightPosition[i].xyz - vertPos);
        
        //Diffuse
        float Idiff = diffuseContribution * max(dot(lightDir,normal), 0.0);
        Idiff = clamp(Idiff, 0.0, 1.0);
        
        //Specular
        vec3 viewDir = normalize(-vertPos);
        vec3 reflectDir = reflect(-lightDir, normal);
        float Ispec = specularContribution * pow(max(dot(reflectDir,viewDir),0.0),specularFocus);
        Ispec = clamp(Ispec, 0.0, 1.0);
        
        vec3 colorLinear = (Ispec + Idiff) * lightIntensity;
        
        R += colorLinear.x;
        G += colorLinear.y;
        B += colorLinear.z;
        
    }
    
    gl_FragColor = vec4(R,G,B, 1.0);
}
