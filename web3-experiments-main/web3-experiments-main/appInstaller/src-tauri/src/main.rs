// Prevents additional console window on Windows in release, DO NOT REMOVE!!
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

// Get the operating system name
#[tauri::command]
fn get_os() -> String {
    std::env::consts::OS.to_string()
}

// Exit the application
#[tauri::command]
fn exit() {
    std::process::exit(0);
}

// Check for chocolatey installation
#[tauri::command]
fn check_chocolatey() -> String {
    let output = std::process::Command::new("powershell.exe")
        .arg("-Command")
        .arg("choco -v")
        .output()
        .expect("failed to execute process");

    let stdout = String::from_utf8(output.stdout).unwrap();
    let stderr = String::from_utf8(output.stderr).unwrap();

    if !stdout.is_empty() {
        return stdout;
    } else {
        return stderr;
    }
}

// Install the chocolatey package manager
#[tauri::command]
fn install_chocolatey() -> String {
    let output = std::process::Command::new("powershell.exe")
        .arg("-Command")
        .arg("Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))")
        .output()
        .expect("failed to execute process");

    let stdout = String::from_utf8(output.stdout).unwrap();
    let stderr = String::from_utf8(output.stderr).unwrap();

    if !stdout.is_empty() {
        return stdout;
    } else {
        return stderr;
    }
}

#[tauri::command]
fn install_chocolatey_package(package: String) -> String {
    let output = std::process::Command::new("powershell.exe")
        .arg("-Command")
        .arg(format!("choco install {} -y", package))
        .output()
        .expect("failed to execute process");

    let stdout = String::from_utf8(output.stdout).unwrap();
    let stderr = String::from_utf8(output.stderr).unwrap();

    if !stdout.is_empty() {
        return stdout;
    } else {
        return stderr;
    }
}

#[tauri::command]
fn uninstall_chocolatey_package(package: String) -> String {
    let output = std::process::Command::new("powershell.exe")
        .arg("-Command")
        .arg(format!("choco uninstall {} -y", package))
        .output()
        .expect("failed to execute process");

    let stdout = String::from_utf8(output.stdout).unwrap();
    let stderr = String::from_utf8(output.stderr).unwrap();

    if !stdout.is_empty() {
        return stdout;
    } else {
        return stderr;
    }
}

#[tauri::command]
fn update_chocolatey_package(package: String) -> String {
    let output = std::process::Command::new("powershell.exe")
        .arg("-Command")
        .arg(format!("choco upgrade {} -y", package))
        .output()
        .expect("failed to execute process");

    let stdout = String::from_utf8(output.stdout).unwrap();
    let stderr = String::from_utf8(output.stderr).unwrap();

    if !stdout.is_empty() {
        return stdout;
    } else {
        return stderr;
    }
}

#[tauri::command]
fn list_chocolatey_packages() -> String {
    let output = std::process::Command::new("powershell.exe")
        .arg("-Command")
        .arg("choco list --local-only")
        .output()
        .expect("failed to execute process");

    let stdout = String::from_utf8(output.stdout).unwrap();
    let stderr = String::from_utf8(output.stderr).unwrap();

    if !stdout.is_empty() {
        return stdout;
    } else {
        return stderr;
    }
}

#[tauri::command]
fn list_chocolatey_packages_outdated() -> String {
    let output = std::process::Command::new("powershell.exe")
        .arg("-Command")
        .arg("choco outdated --local-only")
        .output()
        .expect("failed to execute process");

    let stdout = String::from_utf8(output.stdout).unwrap();
    let stderr = String::from_utf8(output.stderr).unwrap();

    if !stdout.is_empty() {
        return stdout;
    } else {
        return stderr;
    }
}

// get disk usage (get an estimate/chached value so the program doest have to wait for the full calculation and return the value from 0 to 100)
use std::sync::Once;
static INIT: Once = Once::new();
static mut DISK_USAGE: Option<String> = None;
#[tauri::command]
fn get_disk_usage() -> String {
    unsafe {
        INIT.call_once(|| {
            let output = std::process::Command::new("powershell.exe")
                .arg("-Command")
                .arg("Get-PSDrive C | Select-Object Used, Free | ConvertTo-Json")
                .output()
                .expect("failed to execute process");

            let stdout = String::from_utf8(output.stdout).unwrap();
            let stderr = String::from_utf8(output.stderr).unwrap();

            let result = if !stdout.is_empty() {
                let json: serde_json::Value = serde_json::from_str(&stdout).unwrap();
                let used: u64 = json["Used"].as_u64().unwrap();
                let free: u64 = json["Free"].as_u64().unwrap();
                let total: u64 = used + free;
                let percent: f64 = (used as f64 / total as f64) * 100.0;
                // round to 1 decimal places
                format!("{:.1}", percent)
            } else if !stderr.is_empty() {
                let percent: f64 = 0.0;
                percent.to_string()
            } else {
                stderr
            };

            DISK_USAGE = Some(result);
        });

        if let Some(usage) = &DISK_USAGE {
            // Return the cached result if it exists
            return usage.clone();
        }

        panic!("Failed to initialize disk usage");
    }
}

fn main() {
    tauri::Builder::default()
        .invoke_handler(tauri::generate_handler![
            check_chocolatey,
            install_chocolatey,
            install_chocolatey_package,
            uninstall_chocolatey_package,
            update_chocolatey_package,
            list_chocolatey_packages,
            list_chocolatey_packages_outdated,
            get_disk_usage,
            get_os,
            exit
        ])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
