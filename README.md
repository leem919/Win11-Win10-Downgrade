# Win11-Win10-Downgrade
Experimental scripts for downgrade path from Windows 11 to Windows 10.

WARNING: While this has not happened in my testing, there's always a chance that something could go wrong and result in severe issues with your OS. I am not responsible for such issues. Please make the appropriate backups of important data.

1. In Settings, navigate to Accounts > Sign-in options, and disable "For improved security, only allow Windows Hello sign-in for Microsoft accounts on this device"

2. Remove all sign-in options except for your password

3. Download the three scripts from this repository before continuing

4. Mount Windows 10 installation media and run Setup.exe

5. Proceed until you reach the "Choose what to keep" screen

6. In the scripts, run "BypassSetupHostCheck.bat"

7. Proceed through the installation

8. Eventually, the system will reboot and you'll need to sign in with your password

9. After the "Almost There" text, the screen will turn black

10. Wait for a little while and the desktop should appear. If not, try rebooting the computer or signing out and then waiting. You might be able to sign out by pressing the Windows key

11. Go back to the scripts and run ClearStateRepo.bat, enter Y when prompted to stop the State Repository service

12. When done, restart the computer by clicking on desktop and hitting alt+F4

13. Sign back in with your password, you might be prompted to choose your privacy settings again

14. When on the desktop, hit Win+R and enter "wsreset -i", wait for the Microsoft Store to fully install

15. Go back to the scripts, right-click WinPkgRereg.ps1, and run with PowerShell

When it completes, you will have a list of failed packages that you can either try reinstalling yourself or ignoring if you don't need them. Some apps may need to be uninstalled and redownloaded from the store if they don't work right. You can go to Settings > App in the Xbox app to fix some missing dependencies there.

16. Finally, restart the computer. From here you can optionally re-enable other sign-in options
