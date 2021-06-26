use image::{GenericImage, Pixel, Rgba};

#[derive(Copy, Clone, Debug)]
pub struct Color {
    r: u8,
    g: u8,
    b: u8,
    a: f32,
}

impl Color {
    pub fn new(r: u8, g: u8, b: u8, a: f32) -> Self {
        Self { r, g, b, a }
    }
}

impl From<Color> for Rgba<u8> {
    fn from(Color { r, g, b, a }: Color) -> Self {
        Self::from_channels(r, g, b, (a * 255.0).round() as u8)
    }
}

pub fn fill_image<I>(image: &mut I, color: Color)
where
    I: GenericImage<Pixel = Rgba<u8>>,
{
    let color = color.into();

    for y in 0..image.height() {
        for x in 0..image.width() {
            image.put_pixel(x, y, color);
        }
    }
}
