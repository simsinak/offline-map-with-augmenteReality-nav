/*============================================================================== 
 * Copyright (c) 2012-2013 Qualcomm Connected Experiences, Inc. All Rights Reserved. 
 * ==============================================================================*/
using UnityEngine;
using System.Collections;

/// <summary>
/// This class manages different views in the scene like AboutPage, SplashPage and ARCameraView.
/// All of its Init, Update and Draw calls take place via SceneManager's Monobehaviour calls to ensure proper sync across all updates
/// </summary>
public class AppManager : MonoBehaviour {
    
    #region PUBLIC_MEMBER_VARIABLES
    public string TitleForAboutPage = "About";
    public UIEventHandler m_UIEventHandler;
    #endregion PUBLIC_MEMBER_VARIABLES
    
    #region PROTECTED_MEMBER_VARIABLES
    public static ViewType mActiveViewType;
    public enum ViewType { UIVIEW, ARCAMERAVIEW};
    #endregion PROTECTED_MEMBER_VARIABLES
    
    #region PRIVATE_MEMBER_VARIABLES
    private SplashScreenView mSplashView;
    private AboutScreenView mAboutView;
    private float mSecondsVisible = 2.0f;
    #endregion PRIVATE_MEMBER_VARIABLES
    
    //This gets called from SceneManager's Start() 
    public virtual void InitManager () 
    {
       
        m_UIEventHandler.CloseView          += OnTappedOnCloseButton;
        InputController.SingleTapped        += OnSingleTapped;

        
		mActiveViewType = ViewType.ARCAMERAVIEW;
 

    }
    
    public virtual void UpdateManager()
    {
        //Does nothing but anyone extending AppManager can run their update calls here
    }
    
    public virtual void Draw()
    {
        m_UIEventHandler.UpdateView(false);
        switch(mActiveViewType)
        {
        
            case ViewType.UIVIEW:
                m_UIEventHandler.UpdateView(true);
                break;
            
            case ViewType.ARCAMERAVIEW:
                break;
        }
    }
    
    #region UNITY_MONOBEHAVIOUR_METHODS
    
    void OnApplicationPause(bool tf)
    {
        //On hitting the home button, the app tends to turn off the flash
        //So, setting the UI to reflect that
        m_UIEventHandler.SetToDefault(tf);
    }
    
    #endregion UNITY_MONOBEHAVIOUR_METHODS
    
    #region PRIVATE_METHODS
    
    private void OnSingleTapped()
    {
        if(mActiveViewType == ViewType.ARCAMERAVIEW )
        {
            // trigger focus once
            m_UIEventHandler.TriggerAutoFocus();
        }
    }
    
  
    
   
    
 
    
    private void OnTappedOnCloseButton()
    {
        mActiveViewType = ViewType.ARCAMERAVIEW;
    }
    
    private void OnAboutStartButtonTapped()
    {
        mActiveViewType = ViewType.ARCAMERAVIEW;
    }
    
    
    #endregion PRIVATE_METHODS
    
}
