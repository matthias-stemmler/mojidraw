import { Link } from 'react-router-dom';
import { VNode } from 'preact';

const Footer = (): VNode => (
  <footer className="container-fluid mt-auto py-3 bg-light">
    <div className="row justify-content-center">
      <nav className="navbar navbar-expand col-10">
        <ul className="navbar-nav">
          <li className="nav-item me-4">
            <Link to="/" className="nav-link">
              Home
            </Link>
          </li>
          <li className="nav-item me-4">
            <Link to="/gallery" className="nav-link">
              Gallery
            </Link>
          </li>
          <li className="nav-item">
            <Link to="/imprint" className="nav-link">
              Impressum
            </Link>
          </li>
        </ul>
      </nav>
    </div>
  </footer>
);

export default Footer;
