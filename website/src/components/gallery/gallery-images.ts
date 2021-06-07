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

export interface GalleryImageDescriptor {
  title: string;
  src: string;
  size: [number, number];
}

const galleryImages: GalleryImageDescriptor[] = [
  {
    title: 'I Spy',
    src: iSpy,
    size: [672, 672],
  },
  {
    title: 'Happy Hamster',
    src: happyHamster,
    size: [608, 608],
  },
  {
    title: 'Green Smoothie',
    src: greenSmoothie,
    size: [608, 608],
  },
  {
    title: 'Fruity Delight',
    src: fruityDelight,
    size: [608, 608],
  },
  {
    title: 'Good Luck',
    src: goodLuck,
    size: [608, 608],
  },
  {
    title: 'Exotic',
    src: exotic,
    size: [608, 608],
  },
  {
    title: 'Rainbow I',
    src: rainbow1,
    size: [608, 608],
  },
  {
    title: 'Rainbow II',
    src: rainbow2,
    size: [608, 608],
  },
  {
    title: 'Big Apple',
    src: bigApple,
    size: [608, 608],
  },
  {
    title: 'Paradise',
    src: paradise,
    size: [608, 608],
  },
  {
    title: 'Paradise (Stealth Edition)',
    src: paradiseStealth,
    size: [608, 608],
  },
  {
    title: 'Early Bird',
    src: earlyBird,
    size: [608, 608],
  },
  {
    title: 'Happy New Year',
    src: happyNewYear,
    size: [672, 608],
  },
  {
    title: 'Beware',
    src: beware,
    size: [672, 608],
  },
  {
    title: 'Just Relax',
    src: justRelax,
    size: [672, 544],
  },
  {
    title: 'Shooting Star',
    src: shootingStar,
    size: [672, 608],
  },
  {
    title: 'Far Away',
    src: farAway,
    size: [672, 608],
  },
  {
    title: 'Bonne Chance',
    src: bonneChance,
    size: [608, 608],
  },
  {
    title: 'Trèfle',
    src: trefle,
    size: [608, 608],
  },
  {
    title: "It's Magic",
    src: itsMagic,
    size: [608, 608],
  },
  {
    title: 'Fairy Tale',
    src: fairyTale,
    size: [608, 608],
  },
  {
    title: 'Beaver Backlog',
    src: beaverBacklog,
    size: [608, 608],
  },
  {
    title: 'Coco',
    src: coco,
    size: [608, 608],
  },
  {
    title: 'Variety',
    src: variety,
    size: [608, 608],
  },
  {
    title: 'Sunny Side Up',
    src: sunnySideUp,
    size: [608, 608],
  },
  {
    title: 'Which Came First',
    src: whichCameFirst,
    size: [608, 608],
  },
  {
    title: 'Soft Drink',
    src: softDrink,
    size: [608, 608],
  },
  {
    title: 'Enjoy the Show',
    src: enjoyTheShow,
    size: [608, 608],
  },
  {
    title: 'Magic',
    src: magic,
    size: [608, 608],
  },
  {
    title: 'Follow the White Rabbit',
    src: followTheWhiteRabbit,
    size: [608, 608],
  },
  {
    title: 'Surprise',
    src: surprise,
    size: [608, 608],
  },
];

export default galleryImages;
