using System;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using Avalonia.Controls;
using Avalonia.Interactivity;
using System.Collections.Generic;

namespace PointsSlip;

public partial class MainWindow : Window
{
    private string CSV_FILE_PATH = string.Empty;
    private Dictionary<string, NumericUpDown> controlMap = new();
    private bool isInitialized = false;

    public MainWindow()
    {
        // First initialize the component
        InitializeComponent();
        
        try
        {
            // Set up the file path
            string appDataPath = GetAppDataPath();
            Directory.CreateDirectory(appDataPath);
            CSV_FILE_PATH = Path.Combine(appDataPath, "points_data.csv");
            
            // Initialize controls
            InitializeControlMap();
            
            // Mark as initialized before loading values
            isInitialized = true;
            
            // Load saved values
            LoadValuesFromCsv();
            
            // Calculate initial total
            calculate();
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Initialization error: {ex.Message}");
        }
    }

    private static string GetAppDataPath()
    {
        // Base application name
        const string appName = "PointsSlip";

        if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX))
        {
            // For macOS, use the proper Application Support directory
            string userHome = Environment.GetFolderPath(Environment.SpecialFolder.UserProfile);
            return Path.Combine(userHome, "Library", "Application Support", appName);
        }
        else if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
        {
            return Path.Combine(
                Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData),
                appName);
        }
        else
        {
            return Path.Combine(
                Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData),
                appName);
        }
    }

    private void InitializeControlMap()
    {
        controlMap.Clear();
        controlMap.Add("pagesIn", pagesIn);
        controlMap.Add("lecturesIn", lecturesIn);
        controlMap.Add("passcheckoutIn", passcheckoutIn);
        controlMap.Add("givecheckoutIn", givecheckoutIn);
        controlMap.Add("findmuIn", findmuIn);
        controlMap.Add("checkoutdemoIn", checkoutdemoIn);
        controlMap.Add("wordIn", wordIn);
        controlMap.Add("wordclearingIn", wordclearingIn);
        controlMap.Add("theorycoachingIn", theorycoachingIn);
        controlMap.Add("drillIn", drillIn);
        controlMap.Add("verbatimIn", verbatimIn);
        controlMap.Add("practicalIn", practicalIn);
        controlMap.Add("completeshortpracticalIn", completeshortpracticalIn);
        controlMap.Add("completelongpracticalIn", completelongpracticalIn);
        controlMap.Add("checksheetdemoIn", checksheetdemoIn);
        controlMap.Add("demoIn", demoIn);
        controlMap.Add("claydemoIn", claydemoIn);
        controlMap.Add("essayIn", essayIn);
        controlMap.Add("courseIn", courseIn);
        controlMap.Add("coursebonusIn", coursebonusIn);
        controlMap.Add("penaltyIn", penaltyIn);
    }

    private void SaveValuesToCsv()
    {
        if (!isInitialized || string.IsNullOrEmpty(CSV_FILE_PATH)) return;
        
        try
        {
            var data = new List<string>();
            data.Add(string.Join(",", controlMap.Keys));
            data.Add(string.Join(",", controlMap.Values.Select(control => 
                ((double)(control?.Value ?? 0)).ToString("F0"))));

            File.WriteAllLines(CSV_FILE_PATH, data);
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error saving values: {ex.Message}");
        }
    }

    private void LoadValuesFromCsv()
    {
        try
        {
            if (!File.Exists(CSV_FILE_PATH))
            {
                Console.WriteLine("CSV file not found, initializing with zeros");
                InitializeNumericControls();
                return;
            }

            string[] lines = File.ReadAllLines(CSV_FILE_PATH);
            Console.WriteLine($"Read {lines.Length} lines from CSV");
            
            if (lines.Length >= 2)
            {
                string[] headers = lines[0].Split(',');
                string[] values = lines[1].Split(',');

                Console.WriteLine($"Found {headers.Length} headers and {values.Length} values");

                for (int i = 0; i < headers.Length && i < values.Length; i++)
                {
                    if (controlMap.TryGetValue(headers[i], out var control) && 
                        control != null && 
                        double.TryParse(values[i], out double value))
                    {
                        control.Value = (decimal)value;
                        Console.WriteLine($"Loaded {headers[i]} = {value}");
                    }
                    else
                    {
                        Console.WriteLine($"Failed to load value for {headers[i]}");
                    }
                }
            }
            else
            {
                Console.WriteLine("CSV file has insufficient lines");
                InitializeNumericControls();
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error loading values: {ex.Message}");
            InitializeNumericControls();
        }
    }

    private void InitializeNumericControls()
    {
        foreach (var control in controlMap.Values)
        {
            if (control != null)
            {
                control.Value = 0;
            }
        }
    }

    private void OnValueChanged(object? sender, NumericUpDownValueChangedEventArgs e)
    {
        if (!isInitialized) return;
        calculate();
        SaveValuesToCsv();
    }

    public void calculate()
    {
        double pages = (double)(pagesIn?.Value ?? 0);
        double pagesbonusnum = pages / 50;
        double pagesbonus = Math.Round(pagesbonusnum, 0) * 25;
        double pagepoints = pagesbonus + (pages * 10);

        double lectures = (double)(lecturesIn?.Value ?? 0);
        lectures = lectures * 5;

        double passcheckout = (double)(passcheckoutIn?.Value ?? 0);
        passcheckout = passcheckout + (double)(givecheckoutIn?.Value ?? 0);
        double passcheckoutpoints = passcheckout * 3;
        double findmu = (double)(findmuIn?.Value ?? 0);
        double findmupoints = findmu * 5;
        double checkoutdemo = (double)(checkoutdemoIn?.Value ?? 0);
        double checkoutdemopoints = checkoutdemo * 3;

        double word = (double)(wordIn?.Value ?? 0);
        double wordclearing = (double)(wordclearingIn?.Value ?? 0);
        double theorycoaching = (double)(theorycoachingIn?.Value ?? 0);
        double wordpoints = (word * 3) + (wordclearing * 150) + (theorycoaching * 5);

        double drill = (double)(drillIn?.Value ?? 0);
        double drillpoints = drill * 40;

        double verbatim = (double)(verbatimIn?.Value ?? 0);
        double practical = (double)(practicalIn?.Value ?? 0);
        double completeshortpractical = (double)(completeshortpracticalIn?.Value ?? 0);
        double completelongpractical = (double)(completelongpracticalIn?.Value ?? 0);
        double practicalpoints = (verbatim * 10) + (practical * 150) + (completeshortpractical * 100) + (completelongpractical * 500);

        double checksheetdemo = (double)(checksheetdemoIn?.Value ?? 0);
        double demo = (double)(demoIn?.Value ?? 0);
        double claydemo = (double)(claydemoIn?.Value ?? 0);
        double essay = (double)(essayIn?.Value ?? 0);
        double demopoints = (checksheetdemo * 5) + (demo * 3) + (claydemo * 50) + (essay * 10);

        double course = (double)(courseIn?.Value ?? 0) + (double)(coursebonusIn?.Value ?? 0);
        double coursepoints = course * 2000;

        double penalty = (double)(penaltyIn?.Value ?? 0);
        double penaltypoints = penalty * -200;
        
        double points = pagepoints + lectures + passcheckoutpoints + findmupoints + checkoutdemopoints + 
                       wordpoints + drillpoints + practicalpoints + demopoints + coursepoints + penaltypoints;
        
        if (display != null)
        {
            display.Content = points.ToString();
        }
    }
}