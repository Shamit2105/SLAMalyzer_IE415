package com.vslam.orbslam3.vslamactivity;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;

public class DeadReckoning implements SensorEventListener {
    private SensorManager sensorManager;
    private float[] rotationMatrix = new float[9];
    private float[] velocity = new float[]{0,0,0};
    private float[] position = new float[]{0,0,0};
    private long lastTimestamp = 0;
    
    private float[] linearAccel = new float[3];

    public interface Listener {
        void onData(float[] accel, float[] position);
    }

    private Listener listener;

    public DeadReckoning(Context context) {
        sensorManager = (SensorManager) context.getSystemService(Context.SENSOR_SERVICE);
        // Initialize rotation matrix to identity
        rotationMatrix[0] = 1; rotationMatrix[4] = 1; rotationMatrix[8] = 1;
    }

    public void setListener(Listener listener) {
        this.listener = listener;
    }

    public void start() {
        Sensor accel = sensorManager.getDefaultSensor(Sensor.TYPE_LINEAR_ACCELERATION);
        Sensor rotation = sensorManager.getDefaultSensor(Sensor.TYPE_ROTATION_VECTOR);
        
        if (accel != null) sensorManager.registerListener(this, accel, SensorManager.SENSOR_DELAY_GAME);
        if (rotation != null) sensorManager.registerListener(this, rotation, SensorManager.SENSOR_DELAY_GAME);
    }

    public void stop() {
        sensorManager.unregisterListener(this);
    }

    public float[] getPosition() {
        return position;
    }

    public float[] getLinearAccel() {
        return linearAccel;
    }

    public float[] getRotationMatrix() {
        return rotationMatrix;
    }

    @Override
    public void onSensorChanged(SensorEvent event) {
        if (event.sensor.getType() == Sensor.TYPE_ROTATION_VECTOR) {
            SensorManager.getRotationMatrixFromVector(rotationMatrix, event.values);
        }
        
        if (event.sensor.getType() == Sensor.TYPE_LINEAR_ACCELERATION) {
            System.arraycopy(event.values, 0, linearAccel, 0, 3);
            
            if (lastTimestamp == 0) {
                lastTimestamp = event.timestamp;
                return;
            }
            float dt = (event.timestamp - lastTimestamp) * 1.0f / 1000000000.0f;
            lastTimestamp = event.timestamp;

            // Rotate accel to world frame
            // R * acc_device = acc_world
            // rotationMatrix is 3x3 (stored as 9 floats)
            
            float[] accWorld = new float[3];
            accWorld[0] = rotationMatrix[0]*linearAccel[0] + rotationMatrix[1]*linearAccel[1] + rotationMatrix[2]*linearAccel[2];
            accWorld[1] = rotationMatrix[3]*linearAccel[0] + rotationMatrix[4]*linearAccel[1] + rotationMatrix[5]*linearAccel[2];
            accWorld[2] = rotationMatrix[6]*linearAccel[0] + rotationMatrix[7]*linearAccel[1] + rotationMatrix[8]*linearAccel[2];

            // Simple integration
            for(int i=0; i<3; i++) {
                velocity[i] += accWorld[i] * dt;
                position[i] += velocity[i] * dt;
            }

            if (listener != null) {
                listener.onData(linearAccel.clone(), position.clone());
            }
        }
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {
    }
}
