package com.vslam.orbslam3.vslamactivity.obj;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;
import java.util.List;
import android.opengl.GLES20;

public class LinePath {
    private FloatBuffer vertexBuffer;
    private int mProgram;
    private int mPositionHandle;
    private int mColorHandle;
    private int mMVPMatrixHandle;

    // number of coordinates per vertex in this array
    static final int COORDS_PER_VERTEX = 3;
    private int vertexCount = 0;
    private int vertexStride = COORDS_PER_VERTEX * 4; // 4 bytes per vertex

    float color[] = { 0.0f, 0.0f, 1.0f, 1.0f }; // Blue by default

    private final String vertexShaderCode =
        "uniform mat4 uMVPMatrix;" +
        "attribute vec4 vPosition;" +
        "void main() {" +
        "  gl_Position = uMVPMatrix * vPosition;" +
        "}";

    private final String fragmentShaderCode =
        "precision mediump float;" +
        "uniform vec4 vColor;" +
        "void main() {" +
        "  gl_FragColor = vColor;" +
        "}";

    public LinePath() {
        int vertexShader = loadShader(GLES20.GL_VERTEX_SHADER, vertexShaderCode);
        int fragmentShader = loadShader(GLES20.GL_FRAGMENT_SHADER, fragmentShaderCode);

        mProgram = GLES20.glCreateProgram();
        GLES20.glAttachShader(mProgram, vertexShader);
        GLES20.glAttachShader(mProgram, fragmentShader);
        GLES20.glLinkProgram(mProgram);
    }

    public void setPath(List<float[]> points) {
        vertexCount = points.size();
        if (vertexCount == 0) return;

        float[] pathCoords = new float[vertexCount * COORDS_PER_VERTEX];
        for (int i = 0; i < vertexCount; i++) {
            pathCoords[i * 3] = points.get(i)[0];
            pathCoords[i * 3 + 1] = points.get(i)[1];
            pathCoords[i * 3 + 2] = points.get(i)[2];
        }

        ByteBuffer bb = ByteBuffer.allocateDirect(pathCoords.length * 4);
        bb.order(ByteOrder.nativeOrder());
        vertexBuffer = bb.asFloatBuffer();
        vertexBuffer.put(pathCoords);
        vertexBuffer.position(0);
    }

    public void setColor(float r, float g, float b, float a) {
        color[0] = r; color[1] = g; color[2] = b; color[3] = a;
    }

    public void draw(float[] mvpMatrix) {
        if (vertexCount == 0 || vertexBuffer == null) return;

        GLES20.glUseProgram(mProgram);

        mPositionHandle = GLES20.glGetAttribLocation(mProgram, "vPosition");
        GLES20.glEnableVertexAttribArray(mPositionHandle);
        GLES20.glVertexAttribPointer(mPositionHandle, COORDS_PER_VERTEX,
                                     GLES20.GL_FLOAT, false,
                                     vertexStride, vertexBuffer);

        mColorHandle = GLES20.glGetUniformLocation(mProgram, "vColor");
        GLES20.glUniform4fv(mColorHandle, 1, color, 0);

        mMVPMatrixHandle = GLES20.glGetUniformLocation(mProgram, "uMVPMatrix");
        GLES20.glUniformMatrix4fv(mMVPMatrixHandle, 1, false, mvpMatrix, 0);

        GLES20.glLineWidth(5.0f);
        GLES20.glDrawArrays(GLES20.GL_LINE_STRIP, 0, vertexCount);

        GLES20.glDisableVertexAttribArray(mPositionHandle);
    }

    public static int loadShader(int type, String shaderCode){
        int shader = GLES20.glCreateShader(type);
        GLES20.glShaderSource(shader, shaderCode);
        GLES20.glCompileShader(shader);
        return shader;
    }
}
