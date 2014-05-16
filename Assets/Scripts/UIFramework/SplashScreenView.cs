/*============================================================================== 
 * Copyright (c) 2012-2013 Qualcomm Connected Experiences, Inc. All Rights Reserved. 
 * ==============================================================================*/

using UnityEngine;
using System.Collections;

/// <summary>
/// Displays splash image with appropriate size for different device resolutions
/// </summary>
public class SplashScreenView : UIView
{
    #region PRIVATE_MEMBER_VARIABLES
    private Texture mAndroidPotrait;
    private Texture mWindowsPlayModeTexture;
    private Texture mPotraitTextureIPhone;
    private Texture mPotraitTextureIPhone5;
    private Texture mPotraitTextureIPad;
    #endregion PRIVATE_MEMBER_VARIABLES
    
    #region UIView implementation
    public void LoadView ()
    {
        mAndroidPotrait = Resources.Load("SplashScreen/AndroidPotrait") as Texture;
        mWindowsPlayModeTexture = Resources.Load("SplashScreen/WindowsPlayModePotrait") as Texture;
        mPotraitTextureIPhone = Resources.Load("SplashScreen/PotraitTextureIPhone") as Texture;
        mPotraitTextureIPhone5 = Resources.Load("SplashScreen/PotraitTextureIPhone5") as Texture;
        mPotraitTextureIPad = Resources.Load("SplashScreen/PotraitTextureIPad") as Texture;
    }

    public void UnLoadView ()
    {
        Resources.UnloadAsset(mAndroidPotrait);
        Resources.UnloadAsset(mWindowsPlayModeTexture);
        Resources.UnloadAsset(mPotraitTextureIPhone);
        Resources.UnloadAsset(mPotraitTextureIPhone5);
        Resources.UnloadAsset(mPotraitTextureIPad);
    }

    public void UpdateUI (bool tf)
    {
        if(!tf)
            return;
        
         if (QCARRuntimeUtilities.IsPlayMode())
        {
            GUI.DrawTexture(new Rect(0, 0, Screen.width, Screen.height), mWindowsPlayModeTexture);
        }
        else 
        {
            #if UNITY_IPHONE
            
                 if (iPhone.generation == iPhoneGeneration.iPhone5)
                {
                    GUI.DrawTexture(new Rect(0, 0, Screen.width, Screen.height), mPotraitTextureIPhone5);
                }
                else if (iPhone.generation == iPhoneGeneration.iPhone)
                {
                    GUI.DrawTexture(new Rect(0, 0, Screen.width, Screen.height), mPotraitTextureIPhone, ScaleMode.ScaleAndCrop);
                }
                else
                {
                    GUI.DrawTexture(new Rect(0, 0, Screen.width, Screen.height), mPotraitTextureIPad, ScaleMode.ScaleAndCrop);
                }
            #else   
            
                GUI.DrawTexture(new Rect(0, 0, Screen.width, Screen.height), mAndroidPotrait, ScaleMode.ScaleAndCrop);
            
            #endif
        }
    }
    #endregion UIView implementation
}

