use std::process;

use anyhow::Result;
use log::{error, info, LevelFilter};
use rayon::prelude::*;

use crate::args::Args;
use crate::generate::Generator;
use crate::input::Input;

mod args;
mod color;
mod generate;
mod input;
mod layout;
mod path;
mod text;

fn main() {
    pretty_env_logger::formatted_builder()
        .default_format()
        .format_module_path(false)
        .filter_level(LevelFilter::Info)
        .init();

    if let Err(err) = process() {
        error!("{:#}", err);
        process::exit(1);
    }
}

fn process() -> Result<()> {
    let args = Args::from_args();
    let input = Input::from_file(args.input_file())?;

    let generator = Generator::new(input.config())?;

    let count = input.frames().len();
    info!("Processing {} frames", count);

    let width = format!("{}", count - 1).len();

    input
        .frames()
        .into_par_iter()
        .enumerate()
        .for_each(|(index, frame)| {
            let context = format!("FRAME {:0width$}", index, width = width);

            match generator.generate(frame, &context) {
                Ok(..) => info!("[{}] Done", context),
                Err(err) => error!("[{}] Failed: {}", context, err),
            }
        });

    info!("All done");

    Ok(())
}
