import { VNode } from 'preact';
import googlePlayBadge from './google-play-badge.webp';

const Info = (): VNode => (
  <div className="col-10">
    <p>
      <strong>Get the Mojidraw Android app now!</strong>
    </p>
    <button className="google-play-badge border-0 bg-transparent p-0">
      <img
        src={googlePlayBadge}
        alt="Google Play Badge"
        width={226}
        height={67}
      />
    </button>
  </div>
);

export default Info;
