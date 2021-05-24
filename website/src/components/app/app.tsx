import React, { ReactElement } from 'react';
import Header from '../header/header';
import Footer from '../footer/footer';
import Main from '../main/main';

const App = (): ReactElement => (
  <div className="d-flex flex-column h-100">
    <Header />
    <Main />
    <Footer />
  </div>
);

export default App;
