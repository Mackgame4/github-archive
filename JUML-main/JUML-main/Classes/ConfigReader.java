package Classes;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Properties;

public class ConfigReader {
    private static final String CONFIG_FILE = "config.properties";
    private Properties properties;

    // Constructor
    public ConfigReader() {
        this.properties = new Properties();
        loadProperties();
    }

    public void loadProperties() {
        try {
            FileInputStream fileInputStream = new FileInputStream(CONFIG_FILE);
            this.properties.load(fileInputStream);
            fileInputStream.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void saveProperties() {
        try {
            FileOutputStream fileOutputStream = new FileOutputStream(CONFIG_FILE);
            this.properties.store(fileOutputStream, null);
            fileOutputStream.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // Getters/Setters
    public String getProperty(String key) {
        return this.properties.getProperty(key);
    }

    public void setProperty(String key, String value) {
        this.properties.setProperty(key, value);
    }

    // Methods
    public String getPropertyString(String key) {
        return this.properties.getProperty(key).replaceAll("\"", "");
    }

    public int getPropertyInt(String key) {
        return Integer.parseInt(this.properties.getProperty(key));
    }

    public boolean getPropertyBoolean(String key) {
        return Boolean.parseBoolean(this.properties.getProperty(key));
    }
}