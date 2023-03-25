use std::path::{Path, PathBuf};

use clap::Parser;

#[derive(Debug, Parser)]
pub struct Args {
    input_file: PathBuf,
}

impl Args {
    pub fn from_args() -> Self {
        Self::parse()
    }

    pub fn input_file(&self) -> &Path {
        &self.input_file
    }
}
