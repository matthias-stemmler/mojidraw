import { useEffect, useRef } from 'preact/hooks';
import Footer from '../footer/footer';
import Header from '../header/header';
import Main from '../main/main';
import { BrowserRouter as Router } from 'react-router-dom';
import { VNode } from 'preact';

const App = (): VNode => {
  const appRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const handleResize = (): void => {
      appRef.current.style.height = `${window.innerHeight}px`;
    };

    handleResize();

    window.addEventListener('resize', handleResize);
    return () => window.removeEventListener('resize', handleResize);
  }, [appRef]);

  return (
    <div className="d-flex flex-column" ref={appRef}>
      <Router>
        <Header />
        <Main />
        <Footer />
      </Router>
    </div>
  );
};

export default App;
