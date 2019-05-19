using System;
using Foundation;

namespace EhautX.Model
{
    [Register("AppPreferences")]
    public class AppPreferences : NSObject
    {
        #region Computed Properties
        [Export("ServerURL")]
        public string ServerURL
        {
            get => LoadUrl("ServerURL", "http://172.16.154.130:69/cgi-bin/srun_portal");
            set => SaveUrl("ServerURL", value, true);
        }

        [Export("ACID")]
        public string ACID
        {
            get => LoadString("ACID", "1");
            set => SaveString("ACID", value, true);
        }

        [Export("Username")]
        public string Username
        {
            get => LoadString("Username", "");
            set => SaveString("Username", value, true);
        }

        [Export("Password")]
        public string Password
        {
            get => LoadString("Password", "");
            set => SaveString("Password", value, true);
        }

        [Export("PasswordKey")]
        public string PasswordKey
        {
            get => LoadString("PasswordKey", "1234567890");
            set => SaveString("PasswordKey", value, true);
        }

        [Export("Timeout")]
        public int Timeout
        {
            get => LoadInt("Timeout", 3);
            set => SaveInt("Timeout", value, true);
        }

        [Export("Type")]
        public string Type
        {
            get => LoadString("Type", "10");
            set => SaveString("Type", value, true);
        }

        [Export("N")]
        public string N
        {
            get => LoadString("N", "117");
            set => SaveString("N", value, true);
        }

        [Export("Drop")]
        public string Drop
        {
            get => LoadString("Drop", "0");
            set => SaveString("Drop", value, true);
        }

        [Export("Pop")]
        public string Pop
        {
            get => LoadString("Pop", "1");
            set => SaveString("Pop", value, true);
        }

        [Export("MBytes")]
        public string MBytes
        {
            get => LoadString("MBytes", "0");
            set => SaveString("MBytes", value, true);
        }

        [Export("Minutes")]
        public string Minutes
        {
            get => LoadString("Minutes", "0");
            set => SaveString("Minutes", value, true);
        }
        #endregion

        private bool ExistKey(string key)
        {
            var dict = NSUserDefaults.StandardUserDefaults.ToDictionary();
            return dict.ContainsKey(new NSString(key));
        }

        #region Load & Save preference
        private int LoadInt(string key, int defaultValue)
        {
            if (!ExistKey(key)) return defaultValue;
            return (int)NSUserDefaults.StandardUserDefaults.IntForKey(key);
        }

        private void SaveInt(string key, int value, bool sync)
        {
            NSUserDefaults.StandardUserDefaults.SetInt(value, key);
            if (sync) NSUserDefaults.StandardUserDefaults.Synchronize();
        }

        private bool LoadBool(string key, bool defaultValue)
        {
            if (!ExistKey(key)) return defaultValue;
            return NSUserDefaults.StandardUserDefaults.BoolForKey(key);
        }

        private void SaveBool(string key, bool value, bool sync)
        {
            NSUserDefaults.StandardUserDefaults.SetBool(value, key);
            if (sync) NSUserDefaults.StandardUserDefaults.Synchronize();
        }

        private string LoadUrl(string key, string defaultUrl)
        {
            NSUrl url = NSUserDefaults.StandardUserDefaults.URLForKey(key);
            if (!ExistKey(key) || url == null) return defaultUrl;
            return url.ToString();
        }

        private void SaveUrl(string key, string urlString, bool sync)
        {
            NSUserDefaults.StandardUserDefaults.SetURL(new NSUrl(urlString), key);
            if (sync) NSUserDefaults.StandardUserDefaults.Synchronize();
        }

        private string LoadString(string key, string defaultString)
        {
            if (!ExistKey(key)) return defaultString;
            return NSUserDefaults.StandardUserDefaults.StringForKey(key);
        }

        private void SaveString(string key, string value, bool sync)
        {
            NSUserDefaults.StandardUserDefaults.SetString(value, key);
            if (sync) NSUserDefaults.StandardUserDefaults.Synchronize();
        }
        #endregion
    }
}
