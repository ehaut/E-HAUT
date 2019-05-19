using System;
using Foundation;

namespace EhautX.Service
{
    public static class Notify
    {
        public static void Send(string title, string content)
        {
            var notification = new NSUserNotification();
            notification.Title = title;
            notification.InformativeText = content;
            NSUserNotificationCenter.DefaultUserNotificationCenter.ShouldPresentNotification = (center, notify) => true;
            NSUserNotificationCenter.DefaultUserNotificationCenter.ScheduleNotification(notification);
        }
    }
}
