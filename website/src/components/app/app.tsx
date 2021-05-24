import React, { ReactElement } from 'react';
import Footer from '../footer/footer';
import Header from '../header/header';
import Main from '../main/main';
import { BrowserRouter as Router } from 'react-router-dom';

const App = (): ReactElement => (
  <div className="d-flex flex-column h-100">
    <Router>
      <Header />
      <Main />
      <Footer />
    </Router>
  </div>
);

export default App;
