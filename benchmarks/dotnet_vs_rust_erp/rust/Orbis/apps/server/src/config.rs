use std::{
    env,
    net::{AddrParseError, SocketAddr},
    path::PathBuf,
};

#[derive(Debug, Clone)]
pub struct Config {
    pub bind_addr: SocketAddr,
    pub data_dir: PathBuf,
}

#[derive(Debug, thiserror::Error)]
pub enum ConfigError {
    #[error("ORBIS_BIND_ADDR is invalid: {0}")]
    InvalidAddress(#[from] AddrParseError),
}

impl Config {
    pub fn from_env() -> Result<Self, ConfigError> {
        Ok(Self {
            bind_addr: env::var("ORBIS_BIND_ADDR")
                .unwrap_or_else(|_| "127.0.0.1:3000".into())
                .parse()?,
            data_dir: env::var("ORBIS_DATA_DIR")
                .map(PathBuf::from)
                .unwrap_or_else(|_| PathBuf::from(".orbis")),
        })
    }
}
