package com.vslam.orbslam3.vslamactivity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

public class HomeActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_home);

        Button btnSlam = findViewById(R.id.btn_slam);
        btnSlam.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(HomeActivity.this, VslamActivity.class);
                intent.putExtra("MODE", "SLAM");
                startActivity(intent);
            }
        });

        Button btnSlamDr = findViewById(R.id.btn_slam_dr);
        btnSlamDr.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(HomeActivity.this, VslamActivity.class);
                intent.putExtra("MODE", "SLAM_DR");
                startActivity(intent);
            }
        });

        Button btnDrOnly = findViewById(R.id.btn_dr_only);
        btnDrOnly.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(HomeActivity.this, VslamActivity.class);
                intent.putExtra("MODE", "DR_ONLY");
                startActivity(intent);
            }
        });
    }
}
