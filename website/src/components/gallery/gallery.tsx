import { GalleryImageId } from '../../gallery-images/gallery-images';
import GalleryImageRow from '../gallery-image-row/gallery-image-row';
import { VNode } from 'preact';

const galleryImageIds: GalleryImageId[] = [
  GalleryImageId.ISpy,
  GalleryImageId.HappyHamster,
  GalleryImageId.GreenSmoothie,
  GalleryImageId.FruityDelight,
  GalleryImageId.GoodLuck,
  GalleryImageId.Exotic,
  GalleryImageId.Rainbow1,
  GalleryImageId.Rainbow2,
  GalleryImageId.BigApple,
  GalleryImageId.Paradise,
  GalleryImageId.ParadiseStealth,
  GalleryImageId.EarlyBird,
  GalleryImageId.HappyNewYear,
  GalleryImageId.Beware,
  GalleryImageId.JustRelax,
  GalleryImageId.ShootingStar,
  GalleryImageId.FarAway,
  GalleryImageId.BonneChance,
  GalleryImageId.Trefle,
  GalleryImageId.ItsMagic,
  GalleryImageId.FairyTale,
  GalleryImageId.BeaverBacklog,
  GalleryImageId.Coco,
  GalleryImageId.Variety,
  GalleryImageId.SunnySideUp,
  GalleryImageId.WhichCameFirst,
  GalleryImageId.SoftDrink,
  GalleryImageId.EnjoyTheShow,
  GalleryImageId.Magic,
  GalleryImageId.FollowTheWhiteRabbit,
  GalleryImageId.Surprise,
];

const Gallery = (): VNode => (
  <div className="col-11 col-sm-10 container-fluid">
    <GalleryImageRow ids={galleryImageIds} showTitle />
  </div>
);

export default Gallery;
