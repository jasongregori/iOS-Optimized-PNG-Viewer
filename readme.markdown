iPhone Image Viewer
===================

What?
-----

When you compile an app for iOS, it converts PNGs in your app into an optimized form. These cannot be viewed normally on your computer.

This app allows you to view those iphone optimized images.

How?
----

Run this app in the simulator. Find it's Documents folder (you can hit the 'Copy Path' button to find it). Add any iphone optimized PNGs or folders with optimized PNGs in them. The app will filter out any files which are not folders or PNGs, so go ahead and add a whole app bundle or whatever. Hit the refresh button in the app to refresh the files. You can select a file and hit save to save an un-optimized version of the PNG to the "_Saved Images" folder (in Documents).

Why?
----

I use this to look at Apple's iphone images in the SDK. Then I can use them in my apps. You could also use it to check out the images in some other app by copying the bundle from itunes (See below for how to do this).


Contributing
------------

I slapped this together in a day so it is very unoptimized. Feel free to contribute and upgrade code. Some upgrades that would be nice:

* Search
* Fullscreen image view (like the photos app)
* More comments



Viewing images in SDK
---------------------

There are lots of images in the SDK. Some good ones are: 

* /Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator4.0.sdk/System/Library/Frameworks
* /Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator4.0.sdk/System/Library/PrivateFrameworks

You can replace 'iPhoneSimulator4.0.sdk' with different versions.

To view the images just drag the whole folder into iPhone Image Viewer's Documents folder.


Viewing images in any App from iTunes
---------------------------------

1. Right click on app in iTunes and click "Show in Finder"
2. Copy .ipa file to Documents folder
3. Change extension from .ipa to .zip
4. Double-click to extract app from zip file
5. Check it out in iPhone Image Viewer app


Viewing images in .artwork files
--------------------------------

You can't do that with this app, but you can with this one: [http://github.com/0xced/UIKit-Artwork-Extractor]