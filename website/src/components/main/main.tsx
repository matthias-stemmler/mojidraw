import { Route, Switch } from 'react-router-dom';
import Gallery from '../gallery/gallery';
import Imprint from '../imprint/imprint';
import Info from '../info/info';
import { VNode } from 'preact';

const Main = (): VNode => (
  <main className="container-fluid my-4">
    <div className="row justify-content-center">
      <Switch>
        <Route path="/gallery">
          <Gallery />
        </Route>

        <Route path="/imprint">
          <Imprint />
        </Route>

        <Route path="/">
          <Info />
        </Route>
      </Switch>
    </div>
  </main>
);

export default Main;
