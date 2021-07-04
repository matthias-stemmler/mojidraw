import { GalleryImageId } from '../../gallery-images/gallery-images';
import GalleryImageRow from '../gallery-image-row/gallery-image-row';
import googlePlayBadge from './google-play-badge.webp';
import { VNode } from 'preact';

const Info = (): VNode => (
  <div className="col-10">
    <section>
      <p>
        <strong>
          Mojidraw &mdash; the app that lets you become an emoji artist!
        </strong>
      </p>
      <p>
        With this app, you are able to draw fantastic emoji pictures! Make the
        best use of emojis and surprise your family and friends.
      </p>
    </section>
    <div className="d-flex flex-column flex-lg-column-reverse">
      <section className="mt-2 mb-4 mt-lg-5 mb-lg-0">
        <p className="m-0">
          <strong>Get the app for Android now!</strong>
        </p>
        <a href="https://play.google.com/store/apps/details?id=app.mojidraw">
          <button className="google-play-badge border-0 bg-transparent p-0">
            <img
              src={googlePlayBadge}
              alt="Google Play Badge"
              width={226}
              height={67}
            />
          </button>
        </a>
      </section>
      <section className="sample-gallery container-fluid mx-0 px-0">
        <GalleryImageRow
          ids={[
            GalleryImageId.FairyTale,
            GalleryImageId.FollowTheWhiteRabbit,
            GalleryImageId.Surprise,
          ]}
        />
      </section>
    </div>
  </div>
);

export default Info;
