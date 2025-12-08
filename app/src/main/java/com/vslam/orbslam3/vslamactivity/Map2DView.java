package com.vslam.orbslam3.vslamactivity;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.ScaleGestureDetector;
import android.view.GestureDetector;
import android.view.View;
import java.util.ArrayList;
import java.util.List;

public class Map2DView extends View {

    private List<float[]> slamPath = new ArrayList<>();
    private List<float[]> drPath = new ArrayList<>();
    private List<float[]> staticObstacles = new ArrayList<>();
    private List<float[]> dynamicObstacles = new ArrayList<>();
    private float fps = 0;
    
    private Paint slamPaint;
    private Paint drPaint;
    private Paint staticObstaclePaint;
    private Paint dynamicObstaclePaint;
    private Paint textPaint;
    private Paint driftPaint;
    private Paint startPaint;
    private Paint endPaint;
    
    private float minX, maxX, minZ, maxZ;
    
    // Zoom and Pan
    private ScaleGestureDetector scaleDetector;
    private GestureDetector gestureDetector;
    private float zoomFactor = 1.0f;
    private float panX = 0f;
    private float panY = 0f;
    private float globalScale = 1.0f;

    public Map2DView(Context context) {
        super(context);
        init(context);
    }

    public Map2DView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(context);
    }
    
    public void setGlobalScale(float scale) {
        this.globalScale = scale;
        calculateBounds();
        invalidate();
    }

    private void init(Context context) {
        slamPaint = new Paint();
        slamPaint.setColor(Color.BLUE);
        slamPaint.setStrokeWidth(5f);
        slamPaint.setStyle(Paint.Style.STROKE);
        slamPaint.setAntiAlias(true);

        drPaint = new Paint();
        drPaint.setColor(Color.GREEN);
        drPaint.setStrokeWidth(5f);
        drPaint.setStyle(Paint.Style.STROKE);
        drPaint.setAntiAlias(true);
        
        staticObstaclePaint = new Paint();
        staticObstaclePaint.setColor(Color.RED);
        staticObstaclePaint.setStyle(Paint.Style.FILL);
        staticObstaclePaint.setAntiAlias(true);
        
        dynamicObstaclePaint = new Paint();
        dynamicObstaclePaint.setColor(Color.parseColor("#FF8888")); // Light Red
        dynamicObstaclePaint.setStyle(Paint.Style.FILL);
        dynamicObstaclePaint.setAntiAlias(true);
        
        textPaint = new Paint();
        textPaint.setColor(Color.WHITE);
        textPaint.setTextSize(50f); // Increased from 40f
        textPaint.setFakeBoldText(true); // Added bold
        textPaint.setShadowLayer(3f, 1f, 1f, Color.BLACK); // Added shadow
        textPaint.setAntiAlias(true);
        
        driftPaint = new Paint();
        driftPaint.setColor(Color.GREEN);
        driftPaint.setTextSize(50f); // Increased from 40f
        driftPaint.setFakeBoldText(true); // Added bold
        driftPaint.setShadowLayer(3f, 1f, 1f, Color.BLACK); // Added shadow
        driftPaint.setAntiAlias(true);
        
        startPaint = new Paint();
        startPaint.setColor(Color.CYAN);
        startPaint.setStyle(Paint.Style.FILL);
        startPaint.setAntiAlias(true);
        
        endPaint = new Paint();
        endPaint.setColor(Color.MAGENTA);
        endPaint.setStyle(Paint.Style.FILL);
        endPaint.setAntiAlias(true);
        
        // Gesture Detectors
        scaleDetector = new ScaleGestureDetector(context, new ScaleListener());
        gestureDetector = new GestureDetector(context, new GestureListener());
    }
    
    @Override
    public boolean onTouchEvent(MotionEvent event) {
        scaleDetector.onTouchEvent(event);
        gestureDetector.onTouchEvent(event);
        return true;
    }
    
    private class ScaleListener extends ScaleGestureDetector.SimpleOnScaleGestureListener {
        @Override
        public boolean onScale(ScaleGestureDetector detector) {
            zoomFactor *= detector.getScaleFactor();
            zoomFactor = Math.max(0.1f, Math.min(zoomFactor, 10.0f));
            invalidate();
            return true;
        }
    }
    
    private class GestureListener extends GestureDetector.SimpleOnGestureListener {
        @Override
        public boolean onScroll(MotionEvent e1, MotionEvent e2, float distanceX, float distanceY) {
            panX -= distanceX;
            panY -= distanceY;
            invalidate();
            return true;
        }
    }

    public void setPaths(List<float[]> slamPath, List<float[]> drPath, List<float[]> staticObstacles, List<float[]> dynamicObstacles) {
        this.slamPath = slamPath;
        this.drPath = drPath;
        this.staticObstacles = staticObstacles;
        this.dynamicObstacles = dynamicObstacles;
        calculateBounds();
        invalidate();
    }
    
    public void setFps(float fps) {
        this.fps = fps;
        invalidate();
    }

    private void calculateBounds() {
        minX = Float.MAX_VALUE;
        maxX = Float.MIN_VALUE;
        minZ = Float.MAX_VALUE;
        maxZ = Float.MIN_VALUE;

        List<float[]> allPoints = new ArrayList<>();
        allPoints.addAll(slamPath);
        allPoints.addAll(drPath);
        allPoints.addAll(staticObstacles);
        allPoints.addAll(dynamicObstacles);

        if (allPoints.isEmpty()) return;

        for (float[] p : allPoints) {
            float x = p[0] * globalScale;
            float z = p[2] * globalScale;
            if (x < minX) minX = x;
            if (x > maxX) maxX = x;
            if (z < minZ) minZ = z;
            if (z > maxZ) maxZ = z;
        }
        
        float padding = 1.0f;
        minX -= padding;
        maxX += padding;
        minZ -= padding;
        maxZ += padding;
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        canvas.drawColor(Color.BLACK);

        if (slamPath.isEmpty() && drPath.isEmpty()) {
            canvas.drawText("No path data available", 100, 100, textPaint);
            return;
        }

        int width = getWidth();
        int height = getHeight();

        float rangeX = maxX - minX;
        float rangeZ = maxZ - minZ;
        
        if (rangeX == 0) rangeX = 1;
        if (rangeZ == 0) rangeZ = 1;

        float scaleX = width / rangeX;
        float scaleZ = height / rangeZ;
        float scale = Math.min(scaleX, scaleZ) * 0.9f;
        
        // Apply Zoom
        scale *= zoomFactor;

        float offsetX = (width - rangeX * scale) / 2 - minX * scale + panX;
        float offsetZ = (height - rangeZ * scale) / 2 - minZ * scale + panY;

        // Draw Grid (1 meter spacing if scale is correct)
        Paint gridPaint = new Paint();
        gridPaint.setColor(Color.DKGRAY);
        gridPaint.setStrokeWidth(2f);
        
        // Draw a 10x10 grid centered
        for (int i = -10; i <= 10; i++) {
            float x = i * globalScale * scale + offsetX;
            float z = i * globalScale * scale + offsetZ;
            // Vertical lines
            canvas.drawLine(x, 0, x, height, gridPaint);
            // Horizontal lines
            canvas.drawLine(0, z, width, z, gridPaint);
        }

        // Draw Dynamic Obstacles (Small dots)
        for (float[] p : dynamicObstacles) {
            float x = p[0] * globalScale * scale + offsetX;
            float y = p[2] * globalScale * scale + offsetZ;
            canvas.drawCircle(x, y, 2.0f * zoomFactor, dynamicObstaclePaint);
        }

        // Draw Static Obstacles (Large, connected-looking blobs)
        for (float[] p : staticObstacles) {
            float x = p[0] * globalScale * scale + offsetX;
            float y = p[2] * globalScale * scale + offsetZ;
            canvas.drawCircle(x, y, 6.0f * zoomFactor, staticObstaclePaint); // Large radius to simulate outline/blob
        }

        // Draw SLAM Path (Thicker)
        slamPaint.setStrokeWidth(8f * zoomFactor);
        if (!slamPath.isEmpty()) {
            for (int i = 0; i < slamPath.size() - 1; i++) {
                float[] p1 = slamPath.get(i);
                float[] p2 = slamPath.get(i + 1);
                canvas.drawLine(p1[0] * globalScale * scale + offsetX, p1[2] * globalScale * scale + offsetZ,
                                p2[0] * globalScale * scale + offsetX, p2[2] * globalScale * scale + offsetZ, slamPaint);
            }
            // Start Point
            float[] start = slamPath.get(0);
            canvas.drawCircle(start[0] * globalScale * scale + offsetX, start[2] * globalScale * scale + offsetZ, 15f * zoomFactor, startPaint);
            
            // End Point
            float[] end = slamPath.get(slamPath.size() - 1);
            canvas.drawCircle(end[0] * globalScale * scale + offsetX, end[2] * globalScale * scale + offsetZ, 15f * zoomFactor, endPaint);
        }

        // Draw DR Path (Thicker)
        drPaint.setStrokeWidth(8f * zoomFactor);
        if (!drPath.isEmpty()) {
            for (int i = 0; i < drPath.size() - 1; i++) {
                float[] p1 = drPath.get(i);
                float[] p2 = drPath.get(i + 1);
                canvas.drawLine(p1[0] * globalScale * scale + offsetX, p1[2] * globalScale * scale + offsetZ,
                                p2[0] * globalScale * scale + offsetX, p2[2] * globalScale * scale + offsetZ, drPaint);
            }
        }
        
        // Draw Drift Info
        if (!slamPath.isEmpty() && !drPath.isEmpty()) {
            float[] lastSlam = slamPath.get(slamPath.size() - 1);
            float[] lastDr = drPath.get(drPath.size() - 1);
            
            double drift = Math.sqrt(Math.pow((lastSlam[0] - lastDr[0]) * globalScale, 2) + 
                                     Math.pow((lastSlam[1] - lastDr[1]) * globalScale, 2) + 
                                     Math.pow((lastSlam[2] - lastDr[2]) * globalScale, 2));
            
            canvas.drawText(String.format("Drift: %.3f m", drift), 50, height - 100, driftPaint);
        }
        
        // Legend & FPS
        canvas.drawText("SLAM (Blue)", 50, 50, slamPaint);
        canvas.drawText("DR (Green)", 50, 100, drPaint);
        canvas.drawText("Static (Red Blob)", 50, 150, staticObstaclePaint);
        canvas.drawText("Dynamic (Pink Dot)", 50, 200, dynamicObstaclePaint);
        canvas.drawText("Start (Cyan) / End (Magenta)", 50, 250, textPaint);
        canvas.drawText(String.format("FPS: %.1f", fps), 50, 300, textPaint);
    }
}
