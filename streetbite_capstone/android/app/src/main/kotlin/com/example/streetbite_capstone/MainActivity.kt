package com.example.streetbite_capstone

import io.flutter.embedding.android.FlutterFragmentActivity

// local_auth_android attaches its BiometricPrompt to the activity's
// FragmentManager, so a plain FlutterActivity makes every authenticate() call
// fail before the system sheet is ever shown.
class MainActivity : FlutterFragmentActivity()
