// WARNING
//
// This file has been generated automatically by Visual Studio to store outlets and
// actions made in the UI designer. If it is removed, they will be lost.
// Manual changes to this file may not be handled correctly.
//
using Foundation;
using System.CodeDom.Compiler;

namespace EhautX.View
{
	[Register ("ViewController")]
	partial class ViewController
	{
		[Outlet]
		AppKit.NSTextField acidField { get; set; }

		[Outlet]
		AppKit.NSTextField dropField { get; set; }

		[Outlet]
		AppKit.NSTextField macField { get; set; }

		[Outlet]
		AppKit.NSTextField mbytesField { get; set; }

		[Outlet]
		AppKit.NSTextField minutesField { get; set; }

		[Outlet]
		AppKit.NSTextField nField { get; set; }

		[Outlet]
		AppKit.NSTextField popField { get; set; }

		[Outlet]
		AppKit.NSSecureTextField pswdField { get; set; }

		[Outlet]
		AppKit.NSTextField pswdKeyField { get; set; }

		[Outlet]
		AppKit.NSTextField serverField { get; set; }

		[Outlet]
		AppKit.NSTextField typeField { get; set; }

		[Outlet]
		AppKit.NSTextField userField { get; set; }

		[Action ("loginButton:")]
		partial void loginButton (Foundation.NSObject sender);

		[Action ("logoutButton:")]
		partial void logoutButton (Foundation.NSObject sender);
		
		void ReleaseDesignerOutlets ()
		{
			if (serverField != null) {
				serverField.Dispose ();
				serverField = null;
			}

			if (userField != null) {
				userField.Dispose ();
				userField = null;
			}

			if (pswdField != null) {
				pswdField.Dispose ();
				pswdField = null;
			}

			if (pswdKeyField != null) {
				pswdKeyField.Dispose ();
				pswdKeyField = null;
			}

			if (acidField != null) {
				acidField.Dispose ();
				acidField = null;
			}

			if (typeField != null) {
				typeField.Dispose ();
				typeField = null;
			}

			if (nField != null) {
				nField.Dispose ();
				nField = null;
			}

			if (dropField != null) {
				dropField.Dispose ();
				dropField = null;
			}

			if (popField != null) {
				popField.Dispose ();
				popField = null;
			}

			if (mbytesField != null) {
				mbytesField.Dispose ();
				mbytesField = null;
			}

			if (minutesField != null) {
				minutesField.Dispose ();
				minutesField = null;
			}

			if (macField != null) {
				macField.Dispose ();
				macField = null;
			}
		}
	}
}
