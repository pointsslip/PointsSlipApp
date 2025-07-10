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

        double word = (double)wordIn.Value!;
        double wordclearing = (double)wordclearingIn.Value!;
        double theorycoaching = (double)theorycoachingIn.Value!;
        double wordpoints = (word * 3) + (wordclearing * 150) + (theorycoaching * 5);

        double drill = (double)drillIn.Value!;
        double drillpoints = drill * 40;

        double verbatim = (double)verbatimIn.Value!;
        double practical = (double)practicalIn.Value!;
        double completeshortpractical = (double)completeshortpracticalIn.Value!;
        double completelongpractical = (double)completelongpracticalIn.Value!;
        double practicalpoints = (verbatim * 10) + (practical * 150) + (completeshortpractical * 100) + (completelongpractical * 500);

        double checksheetdemo = (double)checksheetdemoIn.Value!;
        double demo = (double)demoIn.Value!;
        double claydemo = (double)claydemoIn.Value!;
        double essay = (double)essayIn.Value!;
        double demopoints = (checksheetdemo * 5) + (demo * 3) + (claydemo * 50) + (essay * 10);

        double course = ((double)courseIn.Value!) + ((double)coursebonusIn.Value!);
        double coursepoints = course * 2000;

        double penalty = (double)penaltyIn.Value!;
        double penaltypoints = penalty * -200;
        
        
        
        double points = pagepoints + lectures + passcheckoutpoints + findmupoints + checkoutdemopoints + wordpoints + drillpoints + practicalpoints + demopoints + coursepoints + penaltypoints;
        double output = points;
        display.Content = output.ToString();
    }

    public void calculateButton(object sender, RoutedEventArgs e)
    {
        calculate();
    }
    
}