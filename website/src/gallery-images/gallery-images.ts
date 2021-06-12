import beaverBacklog from './img/beaver-backlog.webp';
import beware from './img/beware.webp';
import bigApple from './img/big-apple.webp';
import bonneChance from './img/bonne-chance.webp';
import coco from './img/coco.webp';
import earlyBird from './img/early-bird.webp';
import enjoyTheShow from './img/enjoy-the-show.webp';
import exotic from './img/exotic.webp';
import fairyTale from './img/fairy-tale.webp';
import farAway from './img/far-away.webp';
import followTheWhiteRabbit from './img/follow-the-white-rabbit.webp';
import fruityDelight from './img/fruity-delight.webp';
import goodLuck from './img/good-luck.webp';
import greenSmoothie from './img/green-smoothie.webp';
import happyHamster from './img/happy-hamster.webp';
import happyNewYear from './img/happy-new-year.webp';
import iSpy from './img/i-spy.webp';
import itsMagic from './img/its-magic.webp';
import justRelax from './img/just-relax.webp';
import magic from './img/magic.webp';
import paradise from './img/paradise.webp';
import paradiseStealth from './img/paradise-stealth.webp';
import rainbow1 from './img/rainbow-1.webp';
import rainbow2 from './img/rainbow-2.webp';
import shootingStar from './img/shooting-star.webp';
import softDrink from './img/soft-drink.webp';
import sunnySideUp from './img/sunny-side-up.webp';
import surprise from './img/surprise.webp';
import trefle from './img/trefle.webp';
import variety from './img/variety.webp';
import whichCameFirst from './img/which-came-first.webp';

export enum GalleryImageId {
  BeaverBacklog,
  Beware,
  BigApple,
  BonneChance,
  Coco,
  EarlyBird,
  EnjoyTheShow,
  Exotic,
  FairyTale,
  FarAway,
  FollowTheWhiteRabbit,
  FruityDelight,
  GoodLuck,
  GreenSmoothie,
  HappyHamster,
  HappyNewYear,
  ISpy,
  ItsMagic,
  JustRelax,
  Magic,
  Paradise,
  ParadiseStealth,
  Rainbow1,
  Rainbow2,
  ShootingStar,
  SoftDrink,
  SunnySideUp,
  Surprise,
  Trefle,
  Variety,
  WhichCameFirst,
}

export interface GalleryImageDescriptor {
  title: string;
  src: string;
  size: [number, number];
}

export const galleryImageDescriptors: Record<
  GalleryImageId,
  GalleryImageDescriptor
> = {
  [GalleryImageId.BeaverBacklog]: {
    title: 'Beaver Backlog',
    src: beaverBacklog,
    size: [576, 576],
  },
  [GalleryImageId.Beware]: {
    title: 'Beware',
    src: beware,
    size: [640, 576],
  },
  [GalleryImageId.BigApple]: {
    title: 'Big Apple',
    src: bigApple,
    size: [576, 576],
  },
  [GalleryImageId.BonneChance]: {
    title: 'Bonne Chance',
    src: bonneChance,
    size: [576, 576],
  },
  [GalleryImageId.Coco]: {
    title: 'Coco',
    src: coco,
    size: [576, 576],
  },
  [GalleryImageId.EarlyBird]: {
    title: 'Early Bird',
    src: earlyBird,
    size: [576, 576],
  },
  [GalleryImageId.EnjoyTheShow]: {
    title: 'Enjoy the Show',
    src: enjoyTheShow,
    size: [576, 576],
  },
  [GalleryImageId.Exotic]: {
    title: 'Exotic',
    src: exotic,
    size: [576, 576],
  },
  [GalleryImageId.FairyTale]: {
    title: 'Fairy Tale',
    src: fairyTale,
    size: [576, 576],
  },
  [GalleryImageId.FarAway]: {
    title: 'Far Away',
    src: farAway,
    size: [640, 576],
  },
  [GalleryImageId.FollowTheWhiteRabbit]: {
    title: 'Follow the White Rabbit',
    src: followTheWhiteRabbit,
    size: [576, 576],
  },
  [GalleryImageId.FruityDelight]: {
    title: 'Fruity Delight',
    src: fruityDelight,
    size: [576, 576],
  },
  [GalleryImageId.GoodLuck]: {
    title: 'Good Luck',
    src: goodLuck,
    size: [576, 576],
  },
  [GalleryImageId.GreenSmoothie]: {
    title: 'Green Smoothie',
    src: greenSmoothie,
    size: [576, 576],
  },
  [GalleryImageId.HappyHamster]: {
    title: 'Happy Hamster',
    src: happyHamster,
    size: [576, 576],
  },
  [GalleryImageId.HappyNewYear]: {
    title: 'Happy New Year',
    src: happyNewYear,
    size: [640, 576],
  },
  [GalleryImageId.ISpy]: {
    title: 'I Spy',
    src: iSpy,
    size: [640, 640],
  },
  [GalleryImageId.ItsMagic]: {
    title: "It's Magic",
    src: itsMagic,
    size: [576, 576],
  },
  [GalleryImageId.JustRelax]: {
    title: 'Just Relax',
    src: justRelax,
    size: [640, 512],
  },
  [GalleryImageId.Magic]: {
    title: 'Magic',
    src: magic,
    size: [576, 576],
  },
  [GalleryImageId.Paradise]: {
    title: 'Paradise',
    src: paradise,
    size: [576, 576],
  },
  [GalleryImageId.ParadiseStealth]: {
    title: 'Paradise (Stealth Edition)',
    src: paradiseStealth,
    size: [576, 576],
  },
  [GalleryImageId.Rainbow1]: {
    title: 'Rainbow I',
    src: rainbow1,
    size: [576, 576],
  },
  [GalleryImageId.Rainbow2]: {
    title: 'Rainbow II',
    src: rainbow2,
    size: [576, 576],
  },
  [GalleryImageId.ShootingStar]: {
    title: 'Shooting Star',
    src: shootingStar,
    size: [640, 576],
  },
  [GalleryImageId.SoftDrink]: {
    title: 'Soft Drink',
    src: softDrink,
    size: [576, 576],
  },
  [GalleryImageId.SunnySideUp]: {
    title: 'Sunny Side Up',
    src: sunnySideUp,
    size: [576, 576],
  },
  [GalleryImageId.Surprise]: {
    title: 'Surprise',
    src: surprise,
    size: [576, 576],
  },
  [GalleryImageId.Trefle]: {
    title: 'Trèfle',
    src: trefle,
    size: [576, 576],
  },
  [GalleryImageId.Variety]: {
    title: 'Variety',
    src: variety,
    size: [576, 576],
  },
  [GalleryImageId.WhichCameFirst]: {
    title: 'Which Came First',
    src: whichCameFirst,
    size: [576, 576],
  },
};
