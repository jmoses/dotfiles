#!/bin/bash

css = << CSS
@-moz-document url(chrome://browser/content/browser.xhtml) {
  /* https://www.userchrome.org/firefox-changes-userchrome-css.html#fx69 */
  .tabbrowser-tab > .tab-stack > .tab-content[pinned][titlechanged]:not([selected="true"]) {
  
    background-image: none !important;
  }
  
  .tabbrowser-tab[label*="WhatsApp"] > .tab-stack >
  .tab-content[pinned][titlechanged]:not([selected="true"]){
    border-bottom: 2px solid rgba(0, 0, 255, 0.4);
  }
  
}
CSS

profile_dir=''
if [ $(uname -s) = 'Darwin' ] ; then 
    name=$(ls ${HOME}/Library/Application\ Support/Firefox/Profiles/ | grep default-release)
    if [ -x $name ] ; then
        echo "Can't find profile"
        exit 1
    fi
    profile_dir="${HOME}/Library/Application Support/Firefox/Profiles/${name}"
fi

echo "Using profile ${profile_dir}"
prefs="${profile_dir}/prefs.js"
if ! grep legacyUserProfileCustomizations "$prefs" ; then
    echo 'user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);' >> "$prefs"
else
    echo "Preference already set."
fi

userChrome="${profile_dir}/chrome/userChrome.css"
if [[ ! -f $userChrome ]] ; then
    echo "Creating userchrome file"
    mkdir -p $(dirname "${userChrome}")
    cat > "${userChrome}" << CSS
@-moz-document url(chrome://browser/content/browser.xhtml) {
  /* https://www.userchrome.org/firefox-changes-userchrome-css.html#fx69 */
  .tabbrowser-tab > .tab-stack > .tab-content[pinned][titlechanged]:not([selected="true"]) {
  
    background-image: none !important;
  }
  
  .tabbrowser-tab[label*="WhatsApp"] > .tab-stack >
  .tab-content[pinned][titlechanged]:not([selected="true"]){
    border-bottom: 2px solid rgba(0, 0, 255, 0.4);
  }
  
}
CSS
else 
    echo "userChrome already exists"
fi
