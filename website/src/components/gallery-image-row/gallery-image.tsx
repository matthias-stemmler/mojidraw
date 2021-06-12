import {
  GalleryImageDescriptor,
  galleryImageDescriptors,
  GalleryImageId,
} from '../../gallery-images/gallery-images';
import { VNode } from 'preact';

export interface GalleryImageProps {
  id: GalleryImageId;
  showTitle?: boolean;
}

const GalleryImage = (props: GalleryImageProps): VNode => {
  const descriptor: GalleryImageDescriptor = galleryImageDescriptors[props.id];
  const [width, height] = descriptor.size;

  return (
    <figure className="col-12 col-md-6 col-lg-4 d-flex flex-column justify-content-between">
      <img
        src={descriptor.src}
        alt={descriptor.title}
        width={width}
        height={height}
        className="img-fluid"
      />
      {props.showTitle && (
        <figcaption className="text-center mt-3">
          <strong>{descriptor.title}</strong>
        </figcaption>
      )}
    </figure>
  );
};

export default GalleryImage;
