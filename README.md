# Sad Mac Screen Saver

*Stefan Arentz, October 2017*


## Some notes on Notarizing

(Mostly for myself but maybe others find this useful too...)

First _Archive_ a build. Then from the _Organizer_, hit _Distribute Content_ and select the _Built Products_ option. This will export the signed `.saver` file.

Then zip it up so that we can send it to the _Notarization Service_:

```
$ ditto -c -k --keepParent SadMac.saver SadMac.zip
```

Then send it to the _Notarization Service_:

```
$ xcrun altool --notarize-app --primary-bundle-id "$ORG_IDENTIFIER.SadMac.zip" --username $APPSTORE_CONNECT_USERNAME --file SadMac.zip
No errors uploading 'SadMac.zip'.
RequestUUID = ad7daf8e-fae4-475a-b117-dfd572e17a34
```

It will ask for a password, use the _App Specific Password_ you generated for Notarization.

Get some coffee to allow the _Notarization_ to run and then check the status with:

```
$ xcrun altool --notarization-info ad7daf8e-fae4-475a-b117-dfd572e17a34 -u $APPSTORE_CONNECT_USERNAME
No errors getting notarization info.
          Date: 2020-08-25 12:14:19 +0000
          Hash: df90782d2450e6c4f776f4f11c9a49b3036846cd18b632953c119aad12e80af7
   RequestUUID: ad7daf8e-fae4-475a-b117-dfd572e17a34
        Status: in progress
   Status Code: 0
Status Message: Package Approved
```

When the package is approved, staple the token on the original `.saver` file:

```
$ xcrun stapler staple SadMac.saver
Processing: /Users/stefan/Desktop/SadMac-1.3/Products/Users/stefan/Library/Screen Savers/SadMac.saver
Processing: /Users/stefan/Desktop/SadMac-1.3/Products/Users/stefan/Library/Screen Savers/SadMac.saver
The staple and validate action worked!
```

This file can now be zipped and uploaded to the GitHub releases.

(Too many manual steps, so next time we'll make sure this is as simple as `notarize.py SadMac.saver`)
