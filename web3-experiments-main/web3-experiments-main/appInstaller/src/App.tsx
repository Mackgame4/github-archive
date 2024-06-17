import { useState } from "react";
import { invoke } from "@tauri-apps/api/tauri";
import "./App.css";
import appRepo from "./assets/app-repo.json";

// MUI Imports
import Sidebar from "./Sidebar";
import Card from "./Card";
import Button from '@mui/joy/Button';
import Alert from '@mui/joy/Alert';
import Modal from '@mui/joy/Modal';
import ModalDialog from '@mui/joy/ModalDialog';
import CheckIcon from '@mui/icons-material/Check';
import ExitToAppIcon from '@mui/icons-material/ExitToApp';

function App() {
  const [osName, setOsName] = useState<string>("windows");
  const [menuOption, setMenuOption] = useState<number>(0);
  const [chocoInstalled, setChocoInstalled] = useState<boolean>(false);
  const [search, setSearch] = useState<string>("");

  setTimeout(() => {
    invoke("get_os").then((osName) => {
      setOsName(osName as string);
    });

    invoke("check_chocolatey").then((chocoInstalled) => {
      setChocoInstalled(chocoInstalled as boolean);
    });
  }, 1000);

  async function exitApp() {
    await invoke("exit");
  }

  async function installChoco() {
    invoke("install_chocolatey");
    setChocoInstalled(true);
  }

  const [windowReady, setWindowReady] = useState<boolean>(false);
  setTimeout(() => {
    setWindowReady(true);
  }, 2000);

  // Disable context menu on right click (Tauri)
  /*document.addEventListener("contextmenu", (event) => {
    event.preventDefault();
  });*/

  return (
    <main data-tauri-drag-region>
      {
      osName === "windows" && !chocoInstalled && windowReady ?
        <Modal open={true}>
          <ModalDialog color="neutral" layout="center" variant="outlined">
            <Alert color="neutral" size="lg" style={{ marginBottom: "12px" }}>Sorry, but the app requires Chocolatey to be installed.</Alert>
            <Button startDecorator={<CheckIcon />} color="success" sx={{ mb: 1.5 }} onClick={() => installChoco()}>Install Chocolatey</Button>
            <Button startDecorator={<ExitToAppIcon />} color="danger" onClick={() => exitApp()}>Exit App</Button>
          </ModalDialog>
        </Modal>
      :
      <></>
      }
      {
      osName !== "windows" ?
        <Modal open={true}>
          <ModalDialog color="neutral" layout="center" variant="outlined">
            <Alert color="neutral" size="lg" style={{ marginBottom: "12px" }}>Sorry, but the app doesn't support {osName} yet, please come back later.</Alert>
            <Button startDecorator={<ExitToAppIcon />} color="danger" onClick={() => exitApp()}>Exit App</Button>
          </ModalDialog>
        </Modal>
      :
      <div className="app" data-tauri-drag-region>
        <Sidebar menuOption={setMenuOption} search={setSearch} />
        <div className="content" data-tauri-drag-region>
          {menuOption === 0 ? (
          <div className="content-screen-1">
          {appRepo.map((app: any) => {
            if (app.name.toLowerCase().includes(search.toLowerCase())) {
              return (
                <Card info={app} key={app.name} />
              );
            } else {
              return (
                <></>
              );
            }
          })}
          </div>
          )
          : menuOption === 1 ? (
          <div>
            <h1>Installed Apps</h1>
          </div>
          )
          : (
          <div>
            <h1>Coming Soon</h1>
          </div>
          )}
        </div>
      </div>
      }
    </main>
  );
}

export default App;
