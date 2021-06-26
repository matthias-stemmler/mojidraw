use std::convert::TryInto;
use std::fs::File;
use std::io::BufReader;
use std::ops::Deref;
use std::path::{Path, PathBuf};
use std::str::FromStr;

use anyhow::{Context, Error, Result};
use relative_path::{RelativePath, RelativePathBuf};
use serde::Deserialize;
use serde_with::{serde_as, DisplayFromStr};

use crate::color::Color;
use crate::layout::{self, AspectRatio};
use crate::path::dir_of_file;

#[derive(Debug, Deserialize)]
pub struct Input<P> {
    #[serde(flatten)]
    config: Config<P>,

    frames: Vec<Frame<P>>,
}

impl<P> Input<P> {
    pub fn config(&self) -> &Config<P> {
        &self.config
    }

    pub fn frames(&self) -> &[Frame<P>] {
        &self.frames
    }
}

impl<P> Input<P>
where
    P: AsRef<RelativePath>,
{
    fn with_paths<Q>(self, base_path: Q) -> Input<PathBuf>
    where
        Q: AsRef<Path>,
    {
        let base_path = base_path.as_ref();

        let Input { config, frames } = self;
        let Config {
            aspect_ratio,
            background_color,
            bottom_cutoff,
            text,
        } = config;
        let Text {
            font_path,
            color,
            size,
            height,
            margins,
        } = text;

        Input {
            config: Config {
                aspect_ratio,
                background_color,
                bottom_cutoff,
                text: Text {
                    font_path: font_path.as_ref().to_path(base_path),
                    color,
                    size,
                    height,
                    margins,
                },
            },
            frames: frames
                .into_iter()
                .map(|Frame { image_path, text }| Frame {
                    image_path: image_path.as_ref().to_path(base_path),
                    text,
                })
                .collect(),
        }
    }
}

#[serde_as]
#[derive(Debug, Deserialize)]
#[serde(rename_all = "kebab-case")]
pub struct Config<P> {
    #[serde_as(as = "DisplayFromStr")]
    aspect_ratio: AspectRatio,

    #[serde_as(as = "DisplayFromStr")]
    background_color: Color,

    bottom_cutoff: u32,
    text: Text<P>,
}

impl<P> Config<P> {
    pub fn aspect_ratio(&self) -> AspectRatio {
        self.aspect_ratio
    }

    pub fn background_color(&self) -> Color {
        self.background_color
    }

    pub fn bottom_cutoff(&self) -> u32 {
        self.bottom_cutoff
    }

    pub fn text(&self) -> &Text<P> {
        &self.text
    }
}

#[serde_as]
#[derive(Debug, Deserialize)]
pub struct Text<P> {
    #[serde(rename = "font")]
    font_path: P,

    #[serde_as(as = "DisplayFromStr")]
    color: Color,

    size: u32,
    height: u32,
    margins: Insets,
}

impl<P> Text<P> {
    pub fn font_path(&self) -> &P {
        &self.font_path
    }

    pub fn color(&self) -> Color {
        self.color
    }

    pub fn size(&self) -> u32 {
        self.size
    }

    pub fn height(&self) -> u32 {
        self.height
    }

    pub fn margins(&self) -> Insets {
        self.margins
    }
}

#[derive(Copy, Clone, Debug, Deserialize)]
pub struct Insets {
    left: u32,
    top: u32,
    right: u32,
    bottom: u32,
}

impl From<Insets> for layout::Insets {
    fn from(insets: Insets) -> Self {
        layout::Insets::from_ltrb(insets.left, insets.top, insets.right, insets.bottom)
    }
}

#[derive(Debug, Deserialize)]
pub struct Frame<P> {
    #[serde(rename = "image")]
    image_path: P,

    text: String,
}

impl<P> Frame<P> {
    pub fn image_path(&self) -> &P {
        &self.image_path
    }

    pub fn text(&self) -> &str {
        &self.text
    }
}

impl Input<PathBuf> {
    pub fn from_file<P>(path: P) -> Result<Self>
    where
        P: AsRef<Path>,
    {
        let path = path.as_ref();
        let file =
            File::open(path).with_context(|| format!("Could not open {}", path.display()))?;
        let reader = BufReader::new(file);
        let input: Input<RelativePathBuf> = serde_yaml::from_reader(reader)
            .with_context(|| format!("Could not parse {}", path.display()))?;
        let base_path = dir_of_file(path)
            .with_context(|| format!("Could not determine base path for {}", path.display()))?;
        Ok(input.with_paths(base_path))
    }
}

impl FromStr for AspectRatio {
    type Err = Error;

    fn from_str(aspect_ratio_str: &str) -> Result<Self> {
        parse_aspect_ratio(aspect_ratio_str)
            .with_context(|| format!("Invalid aspect ratio: {}", aspect_ratio_str))
    }
}

fn parse_aspect_ratio(aspect_ratio_str: &str) -> Result<AspectRatio> {
    let parts: Vec<u32> = aspect_ratio_str
        .split(':')
        .map(str::trim)
        .map(str::parse)
        .collect::<Result<_, _>>()?;

    let [num, denom]: [u32; 2] = parts.deref().try_into()?;

    Ok(AspectRatio::width_over_height(num, denom))
}

impl FromStr for Color {
    type Err = Error;

    fn from_str(color_str: &str) -> Result<Self> {
        let css_color_parser2::Color { r, g, b, a } = color_str
            .parse()
            .with_context(|| format!("Invalid color: {}", color_str))?;
        Ok(Color::new(r, g, b, a))
    }
}
