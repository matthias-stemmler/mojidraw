import './index.scss';
import App from './components/app/app';
import { render } from 'preact';

const root: HTMLElement = document.getElementById('root')!;
render(<App />, root);
