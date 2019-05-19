using System;

using AppKit;
using CoreFoundation;
using EhautX.Model;
using EhautX.Service;
using Foundation;

namespace EhautX.View
{
    public partial class ViewController : NSViewController
    {
        public static AppDelegate App => (AppDelegate)NSApplication.SharedApplication.Delegate;

        [Export("Preferences")]
        public AppPreferences Preferences => App.Preferences;

        #region Consturctors
        public ViewController(IntPtr handle) : base(handle)
        {
        }
        #endregion

        #region Override Methods
        public override void ViewDidLoad()
        {
            base.ViewDidLoad();

            // Do any additional setup after loading the view.
        }

        public override NSObject RepresentedObject
        {
            get
            {
                return base.RepresentedObject;
            }
            set
            {
                base.RepresentedObject = value;
                // Update the view, if already loaded.
            }
        }
        #endregion

        #region Button clicked action
        partial void loginButton(NSObject sender)
        {
            DispatchQueue.MainQueue.DispatchAsync(() =>
            {
                var username = Crypto.UsernameEncrypt(Preferences.Username);
                var password = Crypto.PasswordEncrypt(Preferences.Password, Preferences.PasswordKey);

                var client = new RestSharp.RestClient();
                var request = new RestSharp.RestRequest(Preferences.ServerURL, RestSharp.Method.POST);
                request.AddParameter("action", "login");
                request.AddParameter("username", username);
                request.AddParameter("password", password);
                request.AddParameter("drop", Preferences.Drop);
                request.AddParameter("pop", Preferences.Pop);
                request.AddParameter("type", Preferences.Type);
                request.AddParameter("n", Preferences.N);
                request.AddParameter("mbytes", Preferences.MBytes);
                request.AddParameter("ac_id", Preferences.ACID);
                request.AddParameter("mac", "02:00:00:00:00:00");
                request.Timeout = Preferences.Timeout * 1000;

                var response = client.Execute(request);
                switch (response.ResponseStatus)
                {
                    case RestSharp.ResponseStatus.TimedOut:
                        Notify.Send("连接错误", "连接超时");
                        break;
                    case RestSharp.ResponseStatus.Error:
                        Notify.Send("连接错误", "连接错误");
                        break;
                    default:
                        Notify.Send("登录状态", response.Content);
                        break;
                }
            });
        }

        partial void logoutButton(NSObject sender)
        {
            DispatchQueue.MainQueue.DispatchAsync(() =>
            {
                var username = Crypto.UsernameEncrypt(Preferences.Username);

                var client = new RestSharp.RestClient();
                var request = new RestSharp.RestRequest(Preferences.ServerURL, RestSharp.Method.POST);
                request.AddParameter("action", "logout");
                request.AddParameter("username", username);
                request.AddParameter("type", Preferences.Type);
                request.AddParameter("ac_id", Preferences.ACID);
                request.AddParameter("mac", "02:00:00:00:00:00");
                request.Timeout = Preferences.Timeout * 1000;

                var response = client.Execute(request);

                switch (response.ResponseStatus)
                {
                    case RestSharp.ResponseStatus.TimedOut:
                        Notify.Send("连接错误", "连接超时");
                        break;
                    case RestSharp.ResponseStatus.Error:
                        Notify.Send("连接错误", "连接错误");
                        break;
                    default:
                        Notify.Send("登出状态", response.Content);
                        break;
                }
            });
        }
        #endregion
    }
}
