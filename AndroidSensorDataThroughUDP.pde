import com.bckmnn.json.*;
import com.bckmnn.udp.*;

import hypermedia.net.*;

CompassManager compass;
AccelerometerManager accelerometer;
float direction;
float ax;
float ay;
float az;

int maxSamples = 5;
float[] samples;
int currentIndex;
float average;

float savedTime;

UDP connection;
String ip ="255.255.255.255";
int port = 11999;


void setup() {
  connection = new UDP(this, 59777);
  compass = new CompassManager(this);
  accelerometer = new AccelerometerManager(this);
  orientation(PORTRAIT);
  savedTime = millis();
  average = 0;
  samples = new float[maxSamples];
  currentIndex = 0;
}

void pause() {
  if (compass != null) compass.pause();
  if (accelerometer != null) {
    accelerometer.pause();
  }
}


void resume() {
  if (compass != null) compass.resume();
  if (accelerometer != null) {
    accelerometer.resume();
  }
}


void draw() {
  background(0);
  /*fill(192, 0, 0);
  textSize(18);
  textAlign(LEFT, UP);
  text("x: " + nf(ax, 1, 2) + "\n" + 
       "y: " + nf(ay, 1, 2) + "\n" + 
       "z: " + nf(az, 1, 2), 
       0, 0, width, height);

  fill(192, 0, 0);
  noStroke();

  translate(width/2, height/2);
  scale(2);
  rotate(direction);
  beginShape();
  vertex(0, -50);
  vertex(-20, 60);
  vertex(0, 50);
  vertex(20, 60);
  endShape(CLOSE);*/
  
  //Send data every 1/60 second
  float passedTime = millis() - savedTime;
  if (passedTime > (1 / 60) * 1000) {
    savedTime = millis();
    connection.send("direction:" + str((float)(((direction * 180) / Math.PI))) + "accelerometer:" + str(average), ip, port);
  }
}


void directionEvent(float newDirection) {
  direction = newDirection;
  //connection.send("direction:" + str((float)(((direction * 180) / Math.PI))), ip, port);
}

public void shakeEvent(float force) {
  //println("shake : " + force);
}


public void accelerationEvent(float x, float y, float z) {
  //ax = x;
  ay = y;
  //az = z;
  samples[currentIndex] = ay;
  currentIndex++;
  if (currentIndex >= maxSamples) {
    for (int i = 0; i < maxSamples; i++) {
      average += samples[i];
      samples[i] = 0;
    }
    average /= maxSamples;
    currentIndex = 0;
  }
  //redraw();
  //connection.send("accelerometer:" + str(ay), ip, port);
}

