import React, { ReactElement } from 'react';
import googlePlayBadge from './google-play-badge.png';

const Main = (): ReactElement => (
  <main className="container-fluid">
    <div className="row justify-content-center">
      <div className="col-10">
        <p className="mt-4">
          <strong>Get the app for Android now!</strong>
        </p>
        <img
          src={googlePlayBadge}
          alt="Google Play Badge"
          className="google-play-badge"
        />
      </div>
    </div>
  </main>
);

export default Main;
