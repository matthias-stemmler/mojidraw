import React, { ReactElement } from 'react';
import { Route, Switch } from 'react-router-dom';
import Imprint from '../imprint/imprint';
import Info from '../info/info';

const Main = (): ReactElement => (
  <main className="container-fluid my-4">
    <div className="row justify-content-center">
      <Switch>
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
