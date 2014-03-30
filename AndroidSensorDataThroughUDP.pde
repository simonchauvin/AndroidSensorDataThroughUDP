import com.bckmnn.json.*;
import com.bckmnn.udp.*;

import hypermedia.net.*;

CompassManager compass;
AccelerometerManager accelerometer;
float direction;
float ax;
float ay;
float az;

UDP connection;
String ip ="255.255.255.255";
int port = 11999;


void setup() {
  connection = new UDP(this, 59777);
  compass = new CompassManager(this);
  accelerometer = new AccelerometerManager(this);
  orientation(PORTRAIT);
  noLoop();
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
}


void directionEvent(float newDirection) {
  direction = newDirection;
  connection.send("direction:" + str((float)(((direction * 180) / Math.PI))), ip, port);
}

public void shakeEvent(float force) {
  println("shake : " + force);
}


public void accelerationEvent(float x, float y, float z) {
//  println("acceleration: " + x + ", " + y + ", " + z);
  ax = x;
  ay = y;
  az = z;
  redraw();
  connection.send("accelerometer:" + str(ay), ip, port);
}

