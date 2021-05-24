import React, { ReactElement } from 'react';
import googlePlayBadge from './google-play-badge.png';

const Info = (): ReactElement => (
  <div className="col-10">
    <p>
      <strong>Get the Mojidraw Android app now!</strong>
    </p>
    <button className="google-play-badge border-0 bg-transparent p-0">
      <img src={googlePlayBadge} alt="Google Play Badge" />
    </button>
  </div>
);

export default Info;
