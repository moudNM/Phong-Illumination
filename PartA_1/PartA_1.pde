/*
Student Name: Nur Muhammad Bin Khameed
SRN: 160269044
CO3355 Advanced Graphics and Animation CW2
Part A1

Instructions:
ControlP5 library must be downloaded for this to work.
Any adjustments to values can be done on the GUI once the sketch is run.
User can change the model (torus or can), specular focus and contribution and
diffuse contribution.
*/

import peasy.*;
import controlP5.*;

PShader lightShader;
PeasyCam cam;
PShape myShape;
int shapeValue = 0;

ControlP5 cp5;
Textlabel specular, diffuse;
float R, G, B;
float spFoc, spCont, dfCont;

void setup() {
  size(500, 500, P3D); 

  //GUI with adjustable values
  cp5 = new ControlP5(this);

  // buttons for torus and can
  cp5.addButton("torus")
    .setBroadcast(false)
    .setValue(0)
    .setPosition(50, 20)
    .setSize(50, 20)
    .setFont(createFont("Helvetica", 12))
    .setBroadcast(true)
    ;

  cp5.addButton("can")
    .setBroadcast(false)
    .setValue(1)
    .setPosition(120, 20)
    .setSize(50, 20)
    .setFont(createFont("Helvetica", 12))
    .setBroadcast(true)
    ;

  //Specular
  specular = cp5.addTextlabel("Specular")
    .setText("Specular Component:")
    .setPosition(260, 340)
    .setColor(255)
    .setFont(createFont("Helvetica", 15))
    ;

  cp5.addSlider("spFoc")
    .setLabel("foc")
    .setColorLabel(255)
    .setPosition(260, 360)
    .setSize(150,20)
    .setRange(0, 100)
    .setValue(30)
    .setFont(createFont("Helvetica", 12))
    ;

  cp5.addSlider("spCont")
    .setLabel("cont")
    .setColorLabel(255)
    .setPosition(260, 390)
    .setSize(150,20)
    .setRange(0, 1)
    .setValue(1)
    .setFont(createFont("Helvetica", 12))
    ;

  //Diffuse
  diffuse = cp5.addTextlabel("Diffuse")
    .setText("Diffuse Component:")
    .setPosition(260, 420)
    .setColor(255)
    .setFont(createFont("Helvetica", 15))
    ;

  cp5.addSlider("dfCont")
    .setLabel("cont")
    .setColorLabel(255)
    .setPosition(260, 440)
    .setSize(150,20)
    .setRange(0, 1)
    .setValue(1)
    .setFont(createFont("Helvetica", 12))
    ;

  cam = new PeasyCam(this, 0, 0, 0, 1500);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(5000);

  lightShader = loadShader("PartAFragmentShader.glsl", "PartAVertexShader.glsl");

  cp5.setAutoDraw(false);
}


void draw() {
  background(170);
  shader(lightShader);
  fill(125);
  noStroke();

  //adjustable values
  //specularFocus/Shinyness
  lightShader.set("specularFocus", spFoc);
  //specularContribution
  lightShader.set("specularContribution", spCont);
  //diffuseContribution
  lightShader.set("diffuseContribution", dfCont);
  //adds ambient component
  lightShader.set("ambientComponent", R, G, B);

  pointLight(0, 255, 0, mouseX-250, mouseY-500, 200);
 
  pushMatrix();
  translate(0, -250);
  if (shapeValue == 0) {
    myShape = getTorus(250, 130, 32, 32);
  } else if (shapeValue == 1) {
    myShape = createCan(150, 300, 32);
  }
  shape(myShape);
  popMatrix();
  cam.beginHUD();
  cp5.draw();
  cam.endHUD();
}

public void torus(int value) {
  println("shape: "+value);
  shapeValue = value;
}

public void can(int value) {
  println("shape: "+value);
  shapeValue = value;
}

PShape getTorus(float outerRad, float innerRad, int numc, int numt) {

  PShape sh = createShape();
  sh.beginShape(TRIANGLE_STRIP);
  sh.noStroke();

  float x, y, z, s, t, u, v;
  float nx, ny, nz;
  float a1, a2;
  int idx = 0;
  for (int i = 0; i < numc; i++) {
    for (int j = 0; j <= numt; j++) {
      for (int k = 1; k >= 0; k--) {
        s = (i + k) % numc + 0.5;
        t = j % numt;
        u = s / numc;
        v = t / numt;
        a1 = s * TWO_PI / numc;
        a2 = t * TWO_PI / numt;

        x = (outerRad + innerRad * cos(a1)) * cos(a2);
        y = (outerRad + innerRad * cos(a1)) * sin(a2);
        z = innerRad * sin(a1);

        nx = cos(a1) * cos(a2); 
        ny = cos(a1) * sin(a2);
        nz = sin(a1);
        sh.normal(nx, ny, nz);
        sh.vertex(x, y, z);
      }
    }
  }
  sh.endShape(); 
  return sh;
}

PShape createCan(float r, float h, int detail) {
  textureMode(NORMAL);
  PShape sh = createShape();
  sh.beginShape(QUAD_STRIP);
  sh.noStroke();
  for (int i = 0; i <= detail; i++) {
    float angle = TWO_PI / detail;
    float x = sin(i * angle);
    float z = cos(i * angle);
    float u = float(i) / detail;
    sh.normal(x, 0, z);
    sh.vertex(x * r, -h/2, z * r, u, 0);
    sh.vertex(x * r, +h/2, z * r, u, 1);
  }
  sh.endShape(); 
  return sh;
}
