import GalleryImage from './gallery-image';
import { GalleryImageId } from '../../gallery-images/gallery-images';
import { VNode } from 'preact';

export interface GalleryImageRowProps {
  ids: GalleryImageId[];
  showTitle?: boolean;
}

const GalleryImageRow = (props: GalleryImageRowProps): VNode => (
  <div className="row g-4">
    {props.ids.map(
      (id: GalleryImageId): VNode => (
        <GalleryImage key={id} id={id} showTitle={props.showTitle} />
      ),
    )}
  </div>
);

export default GalleryImageRow;
