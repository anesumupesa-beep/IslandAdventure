using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

/// <summary>
/// Central helper for all database operations.
/// Uses parameterized queries throughout to prevent SQL injection.
/// </summary>
public static class DBHelper
{
    private static string ConnectionString
    {
        get { return ConfigurationManager.ConnectionStrings["IslandEscapeDB"].ConnectionString; }
    }

    /// <summary>Returns a new open SqlConnection.</summary>
    public static SqlConnection GetConnection()
    {
        SqlConnection conn = new SqlConnection(ConnectionString);
        conn.Open();
        return conn;
    }

    /// <summary>Executes a SELECT and returns a DataTable.</summary>
    public static DataTable ExecuteQuery(string sql, List<SqlParameter> parameters = null)
    {
        DataTable dt = new DataTable();
        using (SqlConnection conn = GetConnection())
        using (SqlCommand cmd = new SqlCommand(sql, conn))
        {
            if (parameters != null)
                cmd.Parameters.AddRange(parameters.ToArray());

            using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                da.Fill(dt);
        }
        return dt;
    }

    /// <summary>Executes INSERT / UPDATE / DELETE. Returns rows affected.</summary>
    public static int ExecuteNonQuery(string sql, List<SqlParameter> parameters = null)
    {
        using (SqlConnection conn = GetConnection())
        using (SqlCommand cmd = new SqlCommand(sql, conn))
        {
            if (parameters != null)
                cmd.Parameters.AddRange(parameters.ToArray());

            return cmd.ExecuteNonQuery();
        }
    }

    /// <summary>Executes a scalar query (e.g. COUNT, MAX, single value).</summary>
    public static object ExecuteScalar(string sql, List<SqlParameter> parameters = null)
    {
        using (SqlConnection conn = GetConnection())
        using (SqlCommand cmd = new SqlCommand(sql, conn))
        {
            if (parameters != null)
                cmd.Parameters.AddRange(parameters.ToArray());

            return cmd.ExecuteScalar();
        }
    }

    // -------------------------------------------------------
    // Convenience parameter builders
    // -------------------------------------------------------

    public static SqlParameter Param(string name, object value)
    {
        return new SqlParameter(name, value ?? DBNull.Value);
    }

    public static SqlParameter ParamInt(string name, int value)
    {
        return new SqlParameter(name, SqlDbType.Int) { Value = value };
    }

    public static SqlParameter ParamString(string name, string value, int size = 255)
    {
        return new SqlParameter(name, SqlDbType.NVarChar, size) { Value = (object)value ?? DBNull.Value };
    }

    public static SqlParameter ParamDecimal(string name, decimal value)
    {
        return new SqlParameter(name, SqlDbType.Decimal) { Value = value, Precision = 10, Scale = 2 };
    }

    public static SqlParameter ParamBit(string name, bool value)
    {
        return new SqlParameter(name, SqlDbType.Bit) { Value = value };
    }
}
