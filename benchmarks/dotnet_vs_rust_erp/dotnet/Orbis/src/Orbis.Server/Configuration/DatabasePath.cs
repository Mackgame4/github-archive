namespace Orbis.Server.Configuration;

public static class DatabasePath
{
    public static string Resolve(IConfiguration configuration, string contentRootPath)
    {
        var configuredDirectory = Environment.GetEnvironmentVariable("ORBIS_DATA_DIR")
            ?? configuration["Orbis:DataDirectory"]
            ?? ".orbis";

        var dataDirectory = Path.IsPathRooted(configuredDirectory)
            ? configuredDirectory
            : Path.Combine(contentRootPath, configuredDirectory);

        Directory.CreateDirectory(dataDirectory);
        return Path.Combine(Path.GetFullPath(dataDirectory), "orbis.db");
    }
}
