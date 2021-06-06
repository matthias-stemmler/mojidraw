import galleryImages, { GalleryImageDescriptor } from './gallery-images';
import GalleryImage from './gallery-image';
import { VNode } from 'preact';

const Gallery = (): VNode => (
  <div className="col-11 col-sm-10 container-fluid">
    <div className="row gy-4">
      {galleryImages.map(
        (props: GalleryImageDescriptor, index: number): VNode => (
          <GalleryImage key={index} {...props} />
        )
      )}
    </div>
  </div>
);

export default Gallery;
