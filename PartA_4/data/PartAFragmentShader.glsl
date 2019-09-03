precision mediump float;

varying vec3 normalInterp;
varying vec3 vertPos;

//set by user
uniform vec3 ambientComponent;
uniform float specularFocus;
uniform float specularContribution;
uniform float diffuseContribution;


uniform int lightCount;
uniform vec4 lightPosition[8];

void main() {
    
    vec3 surfaceColor = vec3(0.0,0.0,0.2);
    vec3 lightIntensity = vec3(0.4,0.0,0.0);
    
    float R = 0.0;
    float G = 0.0;
    float B = 0.0;
    
    for (int i = 0; i < lightCount; i++)
    {
        vec3 normal = normalize(normalInterp);
        vec3 lightDir = normalize(lightPosition[i].xyz - vertPos);
        
        //Ambient
        vec3 Iamb = ambientComponent;
        
        //Diffuse
        float Idiff = diffuseContribution * max(dot(lightDir,normal), 0.0);
        Idiff = clamp(Idiff, 0.0, 1.0);
        
        //Specular
        vec3 viewDir = normalize(-vertPos);
        vec3 reflectDir = reflect(-lightDir, normal);
        float Ispec = specularContribution * pow(max(dot(reflectDir,viewDir),0.0),specularFocus);
        Ispec = clamp(Ispec, 0.0, 1.0);
        
        vec3 colorLinear = Iamb + (Ispec + Idiff) * lightIntensity;
        colorLinear += surfaceColor;
        
        float light = 0.5 * max(0.0, dot(lightDir, normal));
        
        if(i%3==0){
            R += light;
        }else if(i%3==1){
            G += light;
        }else if(i%3==2){
            B += light;
        }
        
        R += colorLinear.x;
        G += colorLinear.y;
        B += colorLinear.z;
        
    }
    
    gl_FragColor = vec4(R,G,B, 1.0);
}
