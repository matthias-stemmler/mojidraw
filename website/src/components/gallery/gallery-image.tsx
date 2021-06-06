import { GalleryImageDescriptor } from './gallery-images';
import { VNode } from 'preact';

export type GalleryImageProps = GalleryImageDescriptor;

const GalleryImage = (props: GalleryImageProps): VNode => {
  const [width, height] = props.size;

  return (
    <div className="col-12 col-sm-6 col-xl-4 d-flex flex-column justify-content-between">
      <img
        src={props.src}
        alt={props.title}
        width={width}
        height={height}
        className="img-fluid"
      />
      <p className="text-center mt-3">
        <strong>{props.title}</strong>
      </p>
    </div>
  );
};

export default GalleryImage;
