# 1. Install Java 11 with Homebrew
brew install openjdk@11


# This should end up under:
ll /usr/local/Cellar/openjdk@11/11.0.12/bin/java


# 2. Download this ApacheDS DMG 2.0.0-M17
# https://archive.apache.org/dist/directory/studio/2.0.0.v20210717-M17/ApacheDirectoryStudio-2.0.0.v20210717-M17-macosx.cocoa.x86_64.dmg
# https://archive.apache.org/dist/directory/studio/2.0.0.v20210717-M17/

# 3. Install the DMG
You should be able to just drag & drop the binary into the Applications folder.
PKG for other versions I tried did NOT work does not let you install it (three is some sort of package restriction)

# 4. Modify to info.plist file to point to Java 11 installed via Homebrew above
/Applications > R-click ApacheDirectorStudio > Show Package Contents > Contents > open info.plist

# 5. Paste this line within the <array> element (there should be examples that are commented out); note the /bin/java at the very end
<string>-vm</string><string>/usr/local/Cellar/openjdk@11/11.0.12/bin/java</string>

# If this Java11 version is your default version, you can get this value by running:
/usr/libexec/java_home
# I had to set it manually:
export JAVA_HOME=/usr/local/Cellar/openjdk@11/11.0.12

# but this is not relevant. It is important that you just point to the Java11 version that works. The Java 11 version recommended on the ApacheDS site is different AdoptOpenJDK, instead of just openjdk. AdoptOpenJDK did not work for me.