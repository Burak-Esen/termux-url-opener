
## Termux Url Opener

#### This is a experimental repo that provides a `termux-url-opener`[(more info)](https://wiki.termux.com/wiki/Intents_and_Hooks) file to give couple of download options.

There are many repositories like this but I wanted to create one more and learn something about bash scripting.

### Prerequesites:
- [`Termux`](https://f-droid.org/packages/com.termux.api/) don't install it from Google's Playstore. Install from F-Droid or Termux website.
- [`Termux:API`](https://f-droid.org/packages/com.termux.api/) plugin will be installed also with `pkg install termux-api` via `setup.sh`. But also need to be installed as an app to your phone.
- Give required permissions to [`Termux`](https://f-droid.org/packages/com.termux.api/) and [`Termux:API`](https://f-droid.org/packages/com.termux.api/) plugin in app settings of your phone.

### Usage

Termux should be selected at share options. It will trigger `termux-url-opener` file. `termux-dialog` will lead user via form activities.

**Current download options:**
- Youtube urls.

**Next features:**
- soundcloud
- direct download via `curl`
