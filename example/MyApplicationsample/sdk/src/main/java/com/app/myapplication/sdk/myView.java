package com.app.myapplication.sdk;

import android.content.Context;
import android.support.constraint.ConstraintLayout;

public class myView extends ConstraintLayout {

    public myView(Context context) {
        super(context);
        initialize(context);
    }

    private void initialize(Context context) {
        inflate(context, R.layout.myview, this);
    }
}
