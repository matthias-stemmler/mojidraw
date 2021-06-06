import { Link } from 'react-router-dom';
import { VNode } from 'preact';
import mojidrawBanner from './mojidraw-banner.webp';

const Header = (): VNode => (
  <header className="container-fluid mb-4 p-4 bg-primary">
    <div className="row justify-content-center">
      <div className="col-10 p-0 d-flex">
        <Link to="/" tabIndex={-1} className="mojidraw-banner w-100">
          <img
            src={mojidrawBanner}
            alt="Mojidraw Banner"
            width={491}
            height={128}
            className="img-fluid"
          />
        </Link>
      </div>
    </div>
  </header>
);

export default Header;
