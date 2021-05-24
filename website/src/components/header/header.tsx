import React, { ReactElement } from 'react';
import mojidrawBanner from './mojidraw-banner.png';

const Header = (): ReactElement => (
  <header className="container-fluid mb-4 p-4 bg-primary">
    <div className="row justify-content-center">
      <div className="col-10 p-0 d-flex">
        <img
          src={mojidrawBanner}
          alt="Mojidraw banner"
          className="mojidraw-banner"
        />
      </div>
    </div>
  </header>
);

export default Header;
