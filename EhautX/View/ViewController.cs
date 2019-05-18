using System;

using AppKit;
using CoreFoundation;
using EhautX.Service;
using Foundation;

namespace EhautX.View
{
    public partial class ViewController : NSViewController
    {
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
                var username = Crypto.UsernameEncrypt(userField.StringValue);
                var password = Crypto.PasswordEncrypt(pswdField.StringValue, pswdKeyField.StringValue);

                var client = new RestSharp.RestClient();
                var request = new RestSharp.RestRequest(serverField.StringValue, RestSharp.Method.POST);
                request.AddParameter("action", "login");
                request.AddParameter("username", username);
                request.AddParameter("password", password);
                request.AddParameter("drop", dropField.StringValue);
                request.AddParameter("pop", popField.StringValue);
                request.AddParameter("type", typeField.StringValue);
                request.AddParameter("n", nField.StringValue);
                request.AddParameter("mbytes", mbytesField.StringValue);
                request.AddParameter("ac_id", acidField.StringValue);
                request.AddParameter("mac", macField.StringValue);
                request.Timeout = 3 * 1000;

                var response = client.Execute(request);
                Console.WriteLine(response.Content);
            });
        }

        partial void logoutButton(NSObject sender)
        {
            DispatchQueue.MainQueue.DispatchAsync(() =>
            {
                var username = Crypto.UsernameEncrypt(userField.StringValue);

                var client = new RestSharp.RestClient();
                var request = new RestSharp.RestRequest(serverField.StringValue, RestSharp.Method.POST);
                request.AddParameter("action", "logout");
                request.AddParameter("username", username);
                request.AddParameter("type", typeField.StringValue);
                request.AddParameter("ac_id", acidField.StringValue);
                request.AddParameter("mac", macField.StringValue);
                request.Timeout = 3 * 1000;

                var response = client.Execute(request);
                Console.WriteLine(response.Content);
            });
        }
        #endregion
    }
}
