use std::ops::Sub;

use image::GenericImageView;

#[derive(Copy, Clone, Debug, PartialEq)]
enum Orientation {
    Portrait,
    Landscape,
}

#[derive(Copy, Clone, Debug)]
pub struct AspectRatio {
    num: u32,
    denom: u32,
}

impl AspectRatio {
    pub fn width_over_height(num: u32, denom: u32) -> Self {
        assert_ne!(num, 0);
        assert_ne!(denom, 0);

        Self { num, denom }
    }

    fn to_orientation(self, orientation: Orientation) -> Self {
        if self.orientation() == orientation {
            self
        } else {
            self.inverted()
        }
    }

    fn orientation(self) -> Orientation {
        if self.num > self.denom {
            Orientation::Landscape
        } else {
            Orientation::Portrait
        }
    }

    fn inverted(self) -> Self {
        Self::width_over_height(self.denom, self.num)
    }

    fn width_to_height(self, width: u32) -> u32 {
        (width as f32 * self.denom as f32 / self.num as f32).ceil() as u32
    }

    fn height_to_width(self, height: u32) -> u32 {
        (height as f32 * self.num as f32 / self.denom as f32).ceil() as u32
    }
}

#[derive(Copy, Clone, Debug, Default)]
pub struct Size {
    pub width: u32,
    pub height: u32,
}

impl Size {
    fn new(width: u32, height: u32) -> Self {
        assert_ne!(width, 0);
        assert_ne!(height, 0);

        Self { width, height }
    }

    fn from_height(height: u32) -> Self {
        Self::default().with_height(height)
    }

    fn with_width(self, width: u32) -> Self {
        Self { width, ..self }
    }

    fn with_height(self, height: u32) -> Self {
        Self { height, ..self }
    }

    fn extend_height(self, delta: u32) -> Self {
        self.with_height(self.height + delta)
    }

    fn orientation(self) -> Orientation {
        AspectRatio::width_over_height(self.width, self.height).orientation()
    }

    fn extend_to_aspect_ratio(self, aspect_ratio: AspectRatio) -> Self {
        let aspect_ratio = aspect_ratio.to_orientation(self.orientation());
        let height = aspect_ratio.width_to_height(self.width);

        if height >= self.height {
            self.with_height(height)
        } else {
            let width = aspect_ratio.height_to_width(self.height);
            self.with_width(width)
        }
    }

    fn center_bottom(self, inner_size: Size) -> Offset {
        Offset::new(
            (self.width - inner_size.width) / 2,
            self.height - inner_size.height,
        )
    }
}

impl Sub<Size> for Size {
    type Output = Size;

    fn sub(self, rhs: Size) -> Self::Output {
        Size::new(self.width - rhs.width, self.height - rhs.height)
    }
}

impl From<Size> for (f32, f32) {
    fn from(size: Size) -> Self {
        (size.width as f32, size.height as f32)
    }
}

pub trait GenericImageViewExt {
    fn size(&self) -> Size;
}

impl<I> GenericImageViewExt for I
where
    I: GenericImageView,
{
    fn size(&self) -> Size {
        Size::new(self.width(), self.height())
    }
}

#[derive(Copy, Clone, Debug)]
pub struct Offset {
    pub x: u32,
    pub y: u32,
}

impl Offset {
    pub fn new(x: u32, y: u32) -> Self {
        Self { x, y }
    }
}

impl From<Offset> for (f32, f32) {
    fn from(offset: Offset) -> Self {
        (offset.x as f32, offset.y as f32)
    }
}

#[derive(Copy, Clone, Debug)]
pub struct Insets {
    left: u32,
    top: u32,
    right: u32,
    bottom: u32,
}

impl Insets {
    pub fn from_ltrb(left: u32, top: u32, right: u32, bottom: u32) -> Self {
        Self {
            left,
            top,
            right,
            bottom,
        }
    }

    fn width(self) -> u32 {
        self.left + self.right
    }

    fn height(self) -> u32 {
        self.top + self.bottom
    }

    fn left_top(self) -> Offset {
        Offset::new(self.left, self.top)
    }
}

#[derive(Copy, Clone, Debug)]
pub struct LayoutParams {
    pub aspect_ratio: AspectRatio,
    pub image_size: Size,
    pub image_bottom_cutoff: u32,
    pub text_height: u32,
    pub text_margins: Insets,
}

#[derive(Copy, Clone, Debug)]
pub struct Layout {
    pub size: Size,
    pub image_position: Offset,
    pub text_position: Offset,
    pub text_bounds: Size,
}

pub fn layout(params: LayoutParams) -> Layout {
    let LayoutParams {
        aspect_ratio,
        image_size,
        image_bottom_cutoff,
        text_height,
        text_margins,
    } = params;

    let image_visible_size = image_size - Size::from_height(image_bottom_cutoff);
    let min_size = image_visible_size.extend_height(text_height + text_margins.height());
    let size = min_size.extend_to_aspect_ratio(aspect_ratio);
    let image_position = size.center_bottom(image_visible_size);
    let text_position = text_margins.left_top();
    let text_bounds = Size::new(size.width - text_margins.width(), text_height);

    Layout {
        size,
        image_position,
        text_position,
        text_bounds,
    }
}
