# JUML
JUML is a simple UML editor written in Java.

## Build
#### Windows
- Download [JDK 21](https://download.oracle.com/java/21/latest/jdk-21_windows-x64_bin.exe) (or newer) from [Oracle](https://www.oracle.com/pt/java/technologies/downloads)

- Fix the PATH environment variable to include the JDK bin folder, or use the following commands:

```bash
./Commands/Batch/win-fix.bat
```

- Use the following commands:

To build:
```bash
./Commands/Batch/build.bat -dev
```

To clean:
```bash
./Commands/Batch/clean.bat
```

To run:
```bash
./Commands/Batch/run.bat -dev
```

- If you want to run the JAR file, use the following commands:

```bash
javac -d build *.java **/*.java
jar cvfm JUML.jar Manifest.txt -C build .
```

```bash
java -jar JUML.jar
```

or:

```bash
./Commands/Batch/build.bat -prod
```

```bash
./Commands/Batch/run.bat -prod
```

#### Linux
- Download [JDK 21](https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.deb) (or newer) from [Oracle](https://www.oracle.com/pt/java/technologies/downloads)

- Use the following commands:

```bash
chmod +x Commands/Bash/build.sh
chmod +x Commands/Bash/clean.sh
chmod +x Commands/Bash/run.sh
```

To build:
```bash
./Commands/Bash/build.sh -dev
```

To clean:
```bash
./Commands/Bash/clean.sh
```

To run:
```bash
./Commands/Bash/run.sh -dev
```

- If you want to run the JAR file, use the following commands:

```bash
javac -d build *.java **/*.java
jar cvfm JUML.jar Manifest.txt -C build .
```

```bash
java -jar JUML.jar
```

or:

```bash
./Commands/Bash/build.sh -prod
```

```bash
./Commands/Bash/run.sh -prod
```

## Run
- Run the built application / JAR file with the following command:

```bash
java -jar JUML.jar
```

or:

```bash
java -cp JUML.jar JUML
```

## Usage

0. Run the application
1. Open a file
2. Select a class
3. Add attributes and methods
4. Save the file

## License
[MIT](#LICENSE.md)