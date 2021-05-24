import React, { ReactElement } from 'react';
import { Link } from 'react-router-dom';
import mojidrawBanner from './mojidraw-banner.png';

const Header = (): ReactElement => (
  <header className="container-fluid mb-4 p-4 bg-primary">
    <div className="row justify-content-center">
      <div className="col-10 p-0 d-flex">
        <Link to="/" tabIndex={-1} className="w-100 d-flex">
          <img
            src={mojidrawBanner}
            alt="Mojidraw banner"
            className="mojidraw-banner"
          />
        </Link>
      </div>
    </div>
  </header>
);

export default Header;
