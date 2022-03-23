import React from 'react';
import { ModeProvider } from '@chia/core';
import AppRouter from './AppRouter';
import {useState} from 'react';
import {useLocalStorage, writeStorage} from '@rehooks/local-storage';
import { Mode } from '@chia/core';

export default function App() {
  // const [modeState, setModeState] = useState<Mode | undefined>(Mode.WALLET);
  writeStorage('mode', Mode.WALLET);
  return (
    <ModeProvider persist>
      <AppRouter />
    </ModeProvider>
  );
}
