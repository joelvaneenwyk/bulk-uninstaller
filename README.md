# Bulk Uninstaller

> [!WARNING]
> This is a fork of [Bulk-Crap-Uninstaller](https://github.com/Klocman/Bulk-Crap-Uninstaller) aka. "BCUninstaller" created by [Marcin Szeniak aka. `Klocman`](https://github.com/Klocman). The project is looking for maintainer(s) so please check [on-going discussion](https://github.com/Klocman/Bulk-Crap-Uninstaller/discussions/289) if you can help. This fork is a work in progress. Use at your own risk!

[![Donate](https://img.shields.io/badge/donate-paypal-brightgreen.svg)](http://klocmansoftware.weebly.com/donate.html)
[![License](https://img.shields.io/github/license/joelvaneenwyk/bulk-uninstaller.svg)](https://github.com/joelvaneenwyk/bulk-uninstaller/blob/develop/LICENSE)

`Bulk Uninstaller` (or `Bulk Crap Uninstaller`, `BCUninstaller`, `bulk-uninstaller`, or even `BCU`) is a free (as in speech) program uninstaller. It excels at removing large amounts of applications with minimal user input. It can clean up leftovers, detect orphaned applications, run uninstallers according to premade lists, and much more! Even though BCU was made with IT pros in mind, by default it is so straight-forward that anyone can use it.

`BCU` is fully compatible with Windows Store Apps, Steam, Windows Features and has special support for many uninstalling systems (`NSIS`, `InnoSetup`, `Msiexec`, and many other). Check below for a full list of functions.

You need Windows 7 or newer to run it (if you get an error on startup then try running Windows Update). If you want to use on Vista or older, check the [Bulk-Crap-Uninstaller legacy 4.x branch](https://github.com/Klocman/Bulk-Crap-Uninstaller/tree/legacy-4.x) or download the latest available [4.x release](https://github.com/Klocman/Bulk-Crap-Uninstaller/releases/tag/v4.16).

`Bulk Crap Uninstaller` is licensed under Apache 2.0 open source license, and can be used in both private and commercial settings for free and with no obligations, as long as no conditions of the license are broken.

[Visit the official homepage](https://www.bcuninstaller.com/) to see the full list of quirks and features!

[Read the online documentation](https://htmlpreview.github.io/?https://github.com/Klocman/Bulk-Crap-Uninstaller/blob/master/doc/BCU_manual.html) if you have any questions or issues (the help file included with all releases). If you didn't find an answer to your question, feel free to [open a new issue](https://github.com/Klocman/Bulk-Crap-Uninstaller/issues/new).

## Compiling

Any modern version of Visual Studio should work.

> [!WARNING]
> The following guidance seems to be obsolete and no longer necessary but keeping until validated for sure.

You might need to download [this](https://github.com/Klocman/UpdateSystem) and [this](https://sourceforge.net/p/kloctoolslibrary/) library separately. If you don't want to make any changes in them you can point the projects to .dll files from the latest release of BCU instead.

## Screenshots

![Bulk Crap Uninstaller window showing many elements of interface](./doc/site/assets/1.png)

![Leftover removal dialog showing options available after uninstall](./doc/site/assets/4.png)

## Alternatives

- [bloatbox: ☑️🌠 Remove Bloatwares from Windows](https://github.com/builtbybel/bloatbox)
