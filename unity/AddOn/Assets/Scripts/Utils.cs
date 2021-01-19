using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using UnityEngine;

public class Utils : MonoBehaviour
{
    #if UNITY_IPHONE
    [DllImport ("__Internal")]
    private static extern float FooPluginFunction ();
    #endif

    void Awake () {
        Debug.Log("Utils # Awake()");
        #if UNITY_IPHONE
        print (FooPluginFunction ());
        #elif UNITY_ANDROID
        //AndroidJavaObject jo = new AndroidJavaObject("com.example.Utils", "fooPluginFunction");
        using (AndroidJavaClass cls = new AndroidJavaClass("com.example.Utils")) {
            Debug.Log("FooPluginFunction: " + cls.CallStatic<double>("fooPluginFunction"));
        }
        #endif
    }

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
