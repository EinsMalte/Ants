// Import necessary AWT classes
import java.awt.GraphicsDevice;
import java.awt.GraphicsEnvironment;

// Camera parameters
float camX = 0, camY = 0; // Camera position
float targetCamX = 0, targetCamY = 0; // Target position for easing
float zoom = 1; // Camera zoom
float targetZoom = 1; // Target zoom for easing

// Key states
boolean moveUp = false;
boolean moveDown = false;
boolean moveLeft = false;
boolean moveRight = false;

void setup() {
  fullScreen(P2D); // Use the 2D render engine for performance

  // Get the default screen device
  GraphicsDevice gd = GraphicsEnvironment.getLocalGraphicsEnvironment().getDefaultScreenDevice();

  // Get the refresh rate of the display
  int refreshRate = gd.getDisplayMode().getRefreshRate();

  // Display the refresh rate in the console
  if (refreshRate == 0) {
    println("Refresh rate: Unknown (could be due to the display using a variable refresh rate)");
    frameRate(60);
  } else {
    println("Refresh rate: " + refreshRate + " Hz");
    frameRate(refreshRate);
  }
}

void draw() {
  // Calculate delta time (time elapsed since last frame)
  float deltaTime = 1.0 / frameRate;

  // Ease camera position and zoom
  camX += (targetCamX - camX) * 4 * deltaTime;
  camY += (targetCamY - camY) * 4 * deltaTime;
  zoom += (targetZoom - zoom) * 4 * deltaTime;

  // Apply camera transformation
  translate(width / 2, height / 2);
  scale(zoom);
  translate(-camX, -camY);

  // Background
  background(10);

  // Draw a grid for reference
  stroke(255, 50);
  for (int x = -5000; x <= 5000; x += 100) {
    line(x, -5000, x, 5000);
  }
  for (int y = -5000; y <= 5000; y += 100) {
    line(-5000, y, 5000, y);
  }

  // Draw a fixed rectangle at the origin
  fill(255, 0, 0);
  rect(-50, -50, 100, 100);

  // Handle input for camera movement
  handleInput(deltaTime);
}

void handleInput(float deltaTime) {
  float moveSpeed = 500; // Movement speed in units per second

  // Update target positions based on key states
  if (moveUp) targetCamY -= moveSpeed * deltaTime;
  if (moveDown) targetCamY += moveSpeed * deltaTime;
  if (moveLeft) targetCamX -= moveSpeed * deltaTime;
  if (moveRight) targetCamX += moveSpeed * deltaTime;

  // Clamp zoom to prevent flipping or extreme zooming
  targetZoom = constrain(targetZoom, 0.1, 5);
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  targetZoom -= e * 0.05; // Adjust zoom speed with scroll
  targetZoom = constrain(targetZoom, 0.1, 5); // Clamp zoom
}

void keyPressed() {
  if (key == 'w' || key == 'W') moveUp = true;
  if (key == 's' || key == 'S') moveDown = true;
  if (key == 'a' || key == 'A') moveLeft = true;
  if (key == 'd' || key == 'D') moveRight = true;
}

void keyReleased() {
  if (key == 'w' || key == 'W') moveUp = false;
  if (key == 's' || key == 'S') moveDown = false;
  if (key == 'a' || key == 'A') moveLeft = false;
  if (key == 'd' || key == 'D') moveRight = false;
}
