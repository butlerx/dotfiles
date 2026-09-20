// pets: package=firefox
// pets: symlink=~/.mozilla/firefox/butlerx.default/user.js
// macOS Firefox reads ~/Library/Application Support/Firefox/Profiles instead
// pets: when=os:linux

// Enable customChrome.css
user_pref('toolkit.legacyUserProfileCustomizations.stylesheets', true);

// Enable CSD
user_pref('browser.tabs.drawInTitlebar', true);

// Set UI density to normal
user_pref('browser.uidensity', 0);
