use orbis_infrastructure::{BulkSeedProgress, SqliteProductRepository};
use std::{env, error::Error, io, path::PathBuf, process::ExitCode};

const DEFAULT_COUNT: u64 = 1_000_000;
const DEFAULT_BATCH_SIZE: u32 = 50_000;

#[derive(Debug)]
struct Options {
    count: u64,
    batch_size: u32,
    database: PathBuf,
    reset: bool,
}

impl Options {
    fn parse() -> Result<Self, String> {
        let mut options = Self {
            count: DEFAULT_COUNT,
            batch_size: DEFAULT_BATCH_SIZE,
            database: default_database_path(),
            reset: false,
        };
        let mut arguments = env::args().skip(1);

        while let Some(argument) = arguments.next() {
            match argument.as_str() {
                "--count" => {
                    options.count = parse_positive(arguments.next().as_deref(), "--count")?;
                }
                "--batch-size" => {
                    let value = parse_positive(arguments.next().as_deref(), "--batch-size")?;
                    options.batch_size =
                        u32::try_from(value).map_err(|_| "--batch-size is too large".to_owned())?;
                }
                "--database" => {
                    options.database = PathBuf::from(
                        arguments
                            .next()
                            .ok_or_else(|| "--database requires a path".to_owned())?,
                    );
                }
                "--reset" => options.reset = true,
                "--help" | "-h" => {
                    print_help();
                    std::process::exit(0);
                }
                _ => return Err(format!("unknown option '{argument}'")),
            }
        }

        Ok(options)
    }
}

#[tokio::main]
async fn main() -> ExitCode {
    match run().await {
        Ok(()) => ExitCode::SUCCESS,
        Err(error) => {
            eprintln!("Seeder failed: {error}");
            ExitCode::FAILURE
        }
    }
}

async fn run() -> Result<(), Box<dyn Error>> {
    let options =
        Options::parse().map_err(|message| io::Error::new(io::ErrorKind::InvalidInput, message))?;
    if let Some(parent) = options
        .database
        .parent()
        .filter(|parent| !parent.as_os_str().is_empty())
    {
        tokio::fs::create_dir_all(parent).await?;
    }

    println!("Database: {}", options.database.display());
    println!("Target generated products: {}", options.count);
    println!("Transaction batch size: {}", options.batch_size);
    if options.reset {
        println!("Reset enabled: existing LOAD-* products will be deleted.");
    }

    let repository = SqliteProductRepository::connect(&options.database).await?;
    let result = repository
        .seed_bulk_products(
            options.count,
            options.batch_size,
            options.reset,
            print_progress,
        )
        .await?;

    println!(
        "Complete. Started with {}, added {}, generated total {}, elapsed {:.2?}.",
        result.initial_count, result.inserted, result.final_count, result.elapsed
    );
    Ok(())
}

fn print_progress(progress: BulkSeedProgress) {
    let percentage = progress.current as f64 / progress.target as f64 * 100.0;
    let rate = if progress.elapsed.is_zero() {
        0.0
    } else {
        progress.inserted as f64 / progress.elapsed.as_secs_f64()
    };
    println!(
        "{}/{} rows ({percentage:.1}%) - {rate:.0} rows/s",
        progress.current, progress.target
    );
}

fn parse_positive(value: Option<&str>, option: &str) -> Result<u64, String> {
    let value = value.ok_or_else(|| format!("{option} requires a value"))?;
    match value.parse::<u64>() {
        Ok(number) if number > 0 => Ok(number),
        _ => Err(format!("{option} must be a positive whole number")),
    }
}

fn default_database_path() -> PathBuf {
    env::var_os("ORBIS_DATA_DIR")
        .map(PathBuf::from)
        .unwrap_or_else(|| PathBuf::from(".orbis"))
        .join("orbis.db")
}

fn print_help() {
    println!(
        "Orbis bulk product seeder\n\n\
         Usage:\n  cargo run -p orbis-seeder --release -- [options]\n\n\
         Options:\n\
           --count <number>       Target generated row count (default: 1000000)\n\
           --batch-size <number>  Rows per transaction (default: 50000)\n\
           --database <path>      SQLite file path (default: .orbis/orbis.db)\n\
           --reset                Delete existing LOAD-* products before seeding\n\
           --help, -h             Show this help"
    );
}
