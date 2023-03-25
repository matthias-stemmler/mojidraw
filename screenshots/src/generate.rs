use std::path::PathBuf;

use anyhow::{Context, Result};
use image::{imageops, DynamicImage};
use log::info;

use crate::color;
use crate::input::{Config, Frame};
use crate::layout::{self, GenericImageViewExt, Layout, LayoutParams};
use crate::path::{self, NormalizedPathExt};
use crate::text::TextRenderer;

pub struct Generator<'a> {
    config: &'a Config<PathBuf>,
    text_renderer: TextRenderer,
}

impl<'a> Generator<'a> {
    pub fn new(config: &'a Config<PathBuf>) -> Result<Self> {
        Ok(Self {
            config,
            text_renderer: TextRenderer::new(
                config.text().font_path(),
                config.text().color(),
                config.text().size(),
            )?,
        })
    }

    pub fn generate(&self, frame: &Frame<PathBuf>, context: &str) -> Result<()> {
        let source_path = frame.image_path();
        let target_path = path::amend_extension(source_path, "out", "png");

        info!(
            "[{}] {} -> {}",
            context,
            source_path.normalized(),
            target_path.normalized()
        );

        let source_image = image::open(source_path)
            .with_context(|| format!("Could not load image {}", source_path.normalized()))?;

        let layout_params = LayoutParams {
            aspect_ratio: self.config.aspect_ratio(),
            image_size: source_image.size(),
            image_bottom_cutoff: self.config.bottom_cutoff(),
            text_height: self.config.text().height(),
            text_margins: self.config.text().margins().into(),
        };

        let Layout {
            size,
            image_position,
            text_position,
            text_bounds,
        } = layout::layout(layout_params);

        let mut target_image = DynamicImage::new_rgba8(size.width, size.height);

        color::fill_image(&mut target_image, self.config.background_color());

        imageops::overlay(
            &mut target_image,
            &source_image,
            image_position.x.into(),
            image_position.y.into(),
        );

        self.text_renderer
            .render(&mut target_image, frame.text(), text_position, text_bounds);

        target_image
            .save(&target_path)
            .with_context(|| format!("Could not save image {}", target_path.normalized()))?;

        Ok(())
    }
}
