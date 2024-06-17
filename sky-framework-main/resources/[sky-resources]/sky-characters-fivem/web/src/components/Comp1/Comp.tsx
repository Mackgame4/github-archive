import React, {useState} from 'react';
import '../App.css'
import {debugData} from "../../utils/debugData";
import {fetchNui} from "../../utils/fetchNui";
import { useAppSelector } from '../../hooks/ReduxHook';
import { useDispatch } from 'react-redux'
import { Slide } from '@mui/material';
//import { setSettings } from './reducer' // Example Disabled by Default -- REDUX
import {useNuiEvent} from "../../hooks/useNuiEvent";

// This will set the NUI to visible if we are
// developing in browser
debugData([
  {
    action: 'setVisible',
    data: true,
  }
])

interface ReturnClientDataCompProps {
  data: any
}

const ReturnClientDataComp: React.FC<ReturnClientDataCompProps> = ({data}) => (
  <>
    <h5>Returned Data:</h5>
    <pre>
      <code>
        {JSON.stringify(data, null)}
      </code>
    </pre>
  </>
)

interface ReturnData {
  x: number;
  y: number;
  z: number;
}

const Comp1: React.FC = () => {
  const settings = useAppSelector(state => state.app)
  const [clientData, setClientData] = useState<ReturnData | null>(null)
  const [currentState, setCurrentState] = useState<boolean>(false)
  useNuiEvent<boolean>('setVisible', setCurrentState)

  console.log('test?')
  const handleGetClientData = () => {
    fetchNui<ReturnData>('getClientData').then(retData => {
      console.log('Got return data from client scripts:')
      console.dir(retData)
      setClientData(retData)
    }).catch(e => {
      console.error('Setting mock data due to error', e)
      setClientData({ x: 500, y: 300, z: 200})
    })
  }

  return (
    <Slide direction="up" in={currentState} mountOnEnter unmountOnExit>
    <div className="nui-wrapper">
      <div className='popup-thing'>
        <div>
          <h1>This is the NUI Popup !</h1>
          <p>Exit with the escape key</p>
          <button onClick={handleGetClientData}>Get Client Data</button>
          {clientData && <ReturnClientDataComp data={clientData} />}
        </div>
      </div>
    </div>
    </Slide>
  );
}

export default Comp1;
