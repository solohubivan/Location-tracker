//
//  AppConstants.swift
//  Location tracker
//
//  Created by Ivan Solohub on 27.05.2025.
//

import Foundation

enum AppConstants {
    
    enum Fonts {
        static let robotoBold = "Roboto-Bold"
        static let robotoRegular = "Roboto-Regular"
        static let robotoMedium = "Roboto-Medium"
    }
    
    enum ImagesNames {
        static let arrowtriangleUpFill: String = "arrowtriangle.up.fill"
        static let locationNorthCircle: String = "location.north.circle"
        static let locationMagnifyingglass: String = "location.magnifyingglass"
        static let personCropCircle: String = "person.crop.circle"
        static let personFill: String = "person.fill"
    }
    
    enum AlertMessages {
        static let successfullyLoggedIn: String = "Successfully logged in!"
        static let loginFailed: String = "Login Failed"
        static let noLocationData: String = "No location data for this day"
        static let successfullySignedUp: String = "Successfully signed up!"
        static let unsuccessful: String = "Unsuccessful"
        static let savingLocationError: String = "Saving location error"
        static let locationError: String = "Location error"
        static let error: String = "Error"
        static let profileImageUpdated: String = "Profile image updated!"
        static let uploadFailed: String = "Upload Failed"
        static let somethingWentWrong: String = "Something went wrong"
        static let failed: String = "Failed"
        static let inputedWrongCurrentPass: String = "Inputed wrong current password"
        static let passChangedSuccessfully: String = "Password changed successfully!"
    }
    
    enum ButtonsTitles {
        static let loginButtonLoadingText: String = "Logging In..."
        static let loginButtonText: String = "Log In"
        static let singUpButtonText: String = "Sign Up!"
        static let editProfileImageButtonText: String = "Edit profile image"
        static let changePasswordButtonText: String = "Change Password"
        static let logoutButtonText: String = "Logout"
    }
    
    enum AlertFactory {
        static let oKButtonText: String = "OK"
        static let settingsAlertTitleText: String = "Access Denied"
        static let settingsAlertMessageText: String = "Go to Settings and allow access to Photos"
        static let cancelButtonText: String = "Cancel"
        static let settingsButtonText: String = "Settings"
        
        static let changePassAlertTitleText = "Change Password"
        static let enterCurrentPassTFPlaceholderText = "Enter current password"
        static let enterNewPassTFPlaceholderText = "Enter new password"
        static let confirmNewPassTFPlaceholderText = "Confirm new password"
        static let changeButtonText = "Change"
        static let locationPermissionAlertTitleText = "Location Access Needed"
        static let locationPermissionAlertMessageText = "Please allow location access in Settings for the app to work correctly."
    }
    
    enum ErrorDescription {
        static let emptyFields: String = "Please enter both email and password."
        static let invalidEmailFormat: String = "Invalid email format."
        static let emptyFields2: String = "Please fill in all fields."
        static let passwordsDoNotMatch: String = "Passwords do not match."
        static let passwordTooShort: String = "Password must be at least 6 characters."
        static let passwordContainsSpaces: String = "Password must not contain spaces."
        static let emptyEmail: String = "Email field must not be empty."
    }
    
    enum LocationMarkerTitles {
        static let locationMarkerStart: String = "Start"
        static let locationMarkerEnd: String = "End"
    }
    
    enum MainTabBarController {
        static let userPartVcTitleText: String = "User"
        static let managerPartVcTitleText: String = "Manager"
        static let profileVcTitleText: String = "Profile"
    }
    
    enum LoginVC {
        static let mainTitleLabelText: String = "Location tracker"
        static let singUpLabelText: String = "Don't have an account?"
    }
    
    enum UserPartVC {
        static let stopSwitcherStatusLabelText: String = "Stop sharing"
        static let startSwitcherStatusLabelText: String = "Start sharing"
        static let onSharingLocationStatusLabelText: String = "Location sharing is ON"
        static let offSharingLocationStatusLabelText: String = "Location sharing is OFF"
        static let disabledSharingLocationStatusLabelText: String = "Sharing location is disabled"
        static let sharingLocationStatusLabelText: String = "Location not sharing"
        static let switcherStatusLabelText: String = "Start sharing"
    }
    
    enum UserProfileVC {
        static let userNameLabelText: String = "User"
    }
}
