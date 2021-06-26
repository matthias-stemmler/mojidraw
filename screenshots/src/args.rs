use std::path::{Path, PathBuf};

use structopt::StructOpt;

#[derive(Debug, StructOpt)]
pub struct Args {
    input_file: PathBuf,
}

impl Args {
    pub fn from_args() -> Self {
        <Self as StructOpt>::from_args()
    }

    pub fn input_file(&self) -> &Path {
        &self.input_file
    }
}
