using System.Text;

namespace EhautX.Service
{
    public static class Crypto
    {
        public static string UsernameEncrypt(string username)
        {
            var sb = new StringBuilder();
            sb.Append("{SRUN3}\r\n");

            for (int i = 0; i < username.Length; ++i)
                sb.Append((char)(username[i] + 4));

            return sb.ToString();
        }

        public static string PasswordEncrypt(string password, string passwordKey)
        {
            var sb = new StringBuilder();

            for (int i = 0; i < password.Length; ++i)
            {
                char ki = (char)(password[i] ^ passwordKey[passwordKey.Length - i % passwordKey.Length - 1]);
                char _l = (char)((ki & 0x0f) + 0x36);
                char _h = (char)((ki >> 4 & 0x0f) + 0x63);
                if (i % 2 == 0)
                    sb.Append($"{_l}{_h}");
                else
                    sb.Append($"{_h}{_l}");
            }

            return sb.ToString();
        }
    }
}
