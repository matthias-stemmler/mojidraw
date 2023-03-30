import { Route, Routes } from 'react-router-dom';
import Gallery from '../gallery/gallery';
import Imprint from '../imprint/imprint';
import Info from '../info/info';
import { VNode } from 'preact';

const Main = (): VNode => (
  <main className="container-fluid my-4">
    <div className="row justify-content-center">
      <Routes>
        <Route path="/gallery" element={<Gallery />} />
        <Route path="/imprint" element={<Imprint />} />
        <Route path="/" element={<Info />} />
      </Routes>
    </div>
  </main>
);

export default Main;
