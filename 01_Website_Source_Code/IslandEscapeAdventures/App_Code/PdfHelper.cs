using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Text;

public static class PdfHelper
{
    public static byte[] BuildPurchaseHistoryPdf(string customerName, DataTableLike orders, DataTableLike items)
    {
        List<string> lines = new List<string>();
        lines.Add("Island Escape Adventures");
        lines.Add("Purchase History - Last 3 Months");
        lines.Add("Customer: " + customerName);
        lines.Add("Generated: " + DateTime.Now.ToString("dd MMM yyyy HH:mm", CultureInfo.InvariantCulture));
        lines.Add("");
        lines.Add("Orders");

        if (orders.Rows.Count == 0)
        {
            lines.Add("No purchases found for the last 3 months.");
        }
        else
        {
            foreach (Dictionary<string, string> row in orders.Rows)
                lines.Add("Order #" + row["OrderID"] + " | " + row["OrderDate"] + " | " + row["ItemCount"] + " item(s) | Rs " + row["TotalAmount"] + " | " + row["PaymentStatus"]);

            lines.Add("");
            lines.Add("Order Details");
            foreach (Dictionary<string, string> row in items.Rows)
                lines.Add("#" + row["OrderID"] + " - " + row["Package"] + " (" + row["Category"] + "), Qty " + row["Quantity"] + ", Rs " + row["Subtotal"]);
        }

        return BuildSimplePdf(lines);
    }

    private static byte[] BuildSimplePdf(List<string> sourceLines)
    {
        List<string> wrapped = new List<string>();
        foreach (string line in sourceLines)
            WrapLine(line, 95, wrapped);

        StringBuilder content = new StringBuilder();
        content.AppendLine("BT");
        content.AppendLine("/F1 11 Tf");
        content.AppendLine("50 790 Td");

        for (int i = 0; i < wrapped.Count && i < 45; i++)
        {
            if (i > 0)
                content.AppendLine("0 -16 Td");
            content.Append("(").Append(Escape(wrapped[i])).AppendLine(") Tj");
        }

        content.AppendLine("ET");
        byte[] contentBytes = Encoding.ASCII.GetBytes(content.ToString());

        List<byte[]> objects = new List<byte[]>();
        objects.Add(Encoding.ASCII.GetBytes("1 0 obj\n<< /Type /Catalog /Pages 2 0 R >>\nendobj\n"));
        objects.Add(Encoding.ASCII.GetBytes("2 0 obj\n<< /Type /Pages /Kids [3 0 R] /Count 1 >>\nendobj\n"));
        objects.Add(Encoding.ASCII.GetBytes("3 0 obj\n<< /Type /Page /Parent 2 0 R /MediaBox [0 0 595 842] /Resources << /Font << /F1 5 0 R >> >> /Contents 4 0 R >>\nendobj\n"));
        objects.Add(Encoding.ASCII.GetBytes("4 0 obj\n<< /Length " + contentBytes.Length.ToString(CultureInfo.InvariantCulture) + " >>\nstream\n" + content.ToString() + "endstream\nendobj\n"));
        objects.Add(Encoding.ASCII.GetBytes("5 0 obj\n<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>\nendobj\n"));

        MemoryStream ms = new MemoryStream();
        WriteAscii(ms, "%PDF-1.4\n");
        List<long> offsets = new List<long>();
        foreach (byte[] obj in objects)
        {
            offsets.Add(ms.Position);
            ms.Write(obj, 0, obj.Length);
        }

        long xref = ms.Position;
        WriteAscii(ms, "xref\n0 6\n");
        WriteAscii(ms, "0000000000 65535 f \n");
        foreach (long offset in offsets)
            WriteAscii(ms, offset.ToString("0000000000", CultureInfo.InvariantCulture) + " 00000 n \n");
        WriteAscii(ms, "trailer\n<< /Size 6 /Root 1 0 R >>\nstartxref\n" + xref.ToString(CultureInfo.InvariantCulture) + "\n%%EOF");

        return ms.ToArray();
    }

    private static void WrapLine(string line, int maxLength, List<string> output)
    {
        if (string.IsNullOrEmpty(line))
        {
            output.Add("");
            return;
        }

        string remaining = line;
        while (remaining.Length > maxLength)
        {
            int split = remaining.LastIndexOf(' ', maxLength);
            if (split < 20)
                split = maxLength;
            output.Add(remaining.Substring(0, split).Trim());
            remaining = remaining.Substring(split).Trim();
        }
        output.Add(remaining);
    }

    private static string Escape(string text)
    {
        return text.Replace("\\", "\\\\").Replace("(", "\\(").Replace(")", "\\)");
    }

    private static void WriteAscii(Stream stream, string text)
    {
        byte[] bytes = Encoding.ASCII.GetBytes(text);
        stream.Write(bytes, 0, bytes.Length);
    }
}

public class DataTableLike
{
    public List<Dictionary<string, string>> Rows = new List<Dictionary<string, string>>();
}
