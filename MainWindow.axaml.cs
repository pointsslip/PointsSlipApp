using System;
using Avalonia.Controls;
using Avalonia.Interactivity;

namespace PointsSlip;

public partial class MainWindow : Window
{
    public MainWindow()
    {
        InitializeComponent();
    }

    public void calculate()
    {
        double pages = (double)pagesIn.Value!;
        double pagesbonusnum = pages / 50;
        double pagesbonus = Math.Round(pagesbonusnum, 0) * 25;
        double pagepoints = pagesbonus + (pages * 10);

        double lectures = (double)lecturesIn.Value!;
        lectures = lectures * 5;

        double passcheckout = (double)passcheckoutIn.Value!;
        passcheckout = passcheckout + (double)givecheckoutIn.Value!;
        double passcheckoutpoints = passcheckout * 3;
        double findmu = (double)findmuIn.Value!;
        double findmupoints = findmu * 5;
        double checkoutdemo = (double)checkoutdemoIn.Value!;
        double checkoutdemopoints = checkoutdemo * 3;
        
        
        
        
        
        double output = pagepoints + lectures + passcheckoutpoints + findmupoints + checkoutdemopoints;
        display.Content = output.ToString();
    }

    public void calculateButton(object sender, RoutedEventArgs e)
    {
        calculate();
    }
    
}