using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices.WindowsRuntime;
using Windows.Foundation;
using Windows.Foundation.Collections;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Controls.Primitives;
using Windows.UI.Xaml.Data;
using Windows.UI.Xaml.Input;
using Windows.UI.Xaml.Media;
using System.Diagnostics;
using Windows.UI.Xaml.Navigation;

// The Blank Page item template is documented at https://go.microsoft.com/fwlink/?LinkId=234238

namespace EcoCarHMI
{
    /// <summary>
    /// An empty page that can be used on its own or navigated to within a Frame.
    /// </summary>
    public sealed partial class SelectionPage : Page
    {
        public SelectionPage()
        {
            this.InitializeComponent();
            
        }

        private void Page_Loaded(object sender, RoutedEventArgs e)
        {
            if (DateTime.Now.TimeOfDay < new TimeSpan(00, 08, 00, 0) || DateTime.Now.TimeOfDay > new TimeSpan(00, 20, 00, 0))
            {
                RequestedTheme = ElementTheme.Dark;
            }
            else
            {
                RequestedTheme = ElementTheme.Light;
            }

        }

        private void NoAssistance_Click(object sender, RoutedEventArgs e)
        {
            //RequestedTheme = ElementTheme.Dark;
            this.Frame.Navigate(typeof(MainPage));
        }

        private void DeafAssistance_Click(object sender, RoutedEventArgs e)
        {

        }

        private void SightAssistance_Click(object sender, RoutedEventArgs e)
        {

        }

        private void MobilityAssistance_Click(object sender, RoutedEventArgs e)
        {
            //RequestedTheme = ElementTheme.Light;
        }
    }
}
