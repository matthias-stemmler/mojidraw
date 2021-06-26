use std::fs;
use std::path::Path;

use ab_glyph::{Font, FontVec, Point, PxScale};
use anyhow::{anyhow, Context, Result};
use glyph_brush_layout::{
    FontId, GlyphPositioner, HorizontalAlign, Layout, SectionGeometry, SectionGlyph, SectionText,
    VerticalAlign,
};
use image::{GenericImage, Pixel, Rgba};
use num_traits::NumCast;

use crate::color::Color;
use crate::layout::{Offset, Size};
use crate::path::NormalizedPathExt;

pub struct TextRenderer {
    font: FontVec,
    color: Rgba<u8>,
    scale: PxScale,
}

impl TextRenderer {
    pub fn new<P>(font_path: P, color: Color, size: u32) -> Result<Self>
    where
        P: AsRef<Path>,
    {
        let font_path = font_path.as_ref();

        Ok(Self {
            font: load_font(font_path)
                .with_context(|| format!("Could not load font {}", font_path.normalized()))?,
            color: color.into(),
            scale: PxScale::from(size as f32),
        })
    }

    pub fn render<I>(&self, image: &mut I, text: &str, position: Offset, bounds: Size)
    where
        I: GenericImage<Pixel = Rgba<u8>>,
    {
        let fonts = [&self.font];

        let position = Offset::new(
            position.x + bounds.width / 2,
            position.y + bounds.height / 2,
        );

        let geometry = SectionGeometry {
            screen_position: position.into(),
            bounds: bounds.into(),
        };

        let sections = [SectionText {
            text,
            scale: self.scale,
            font_id: FontId(0),
        }];

        let section_glyphs = Layout::default()
            .h_align(HorizontalAlign::Center)
            .v_align(VerticalAlign::Center)
            .calculate_glyphs(&fonts, &geometry, &sections);

        let outlined_glyphs = section_glyphs
            .into_iter()
            .filter_map(|SectionGlyph { glyph, .. }| self.font.outline_glyph(glyph));

        for outlined_glyph in outlined_glyphs {
            outlined_glyph.draw(|x, y, c| {
                let (x, y) = offset((x, y), outlined_glyph.px_bounds().min);
                let mut image_color = image.get_pixel(x, y);
                let mut color: Rgba<u8> = self.color;
                color.channels_mut()[3] = NumCast::from((255.0 * c).round()).unwrap_or(0);
                image_color.blend(&color);
                image.put_pixel(x, y, image_color);
            });
        }
    }
}

fn load_font(font_path: &Path) -> Result<FontVec> {
    let bytes = fs::read(font_path)?;
    FontVec::try_from_vec(bytes).map_err(|_| anyhow!("Invalid font"))
}

fn offset((x, y): (u32, u32), offset: Point) -> (u32, u32) {
    (x + offset.x as u32, y + offset.y as u32)
}
