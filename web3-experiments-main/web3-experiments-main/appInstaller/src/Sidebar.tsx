/* eslint-disable jsx-a11y/anchor-is-valid */
import * as React from 'react';
import Box from '@mui/joy/Box';
import Card from '@mui/joy/Card';
import Divider from '@mui/joy/Divider';
import IconButton from '@mui/joy/IconButton';
import Input from '@mui/joy/Input';
import Link from '@mui/joy/Link';
import LinearProgress from '@mui/joy/LinearProgress';
import List from '@mui/joy/List';
import ListItem from '@mui/joy/ListItem';
import ListItemButton from '@mui/joy/ListItemButton';
import ListItemContent from '@mui/joy/ListItemContent';
import ListItemDecorator from '@mui/joy/ListItemDecorator';
import Typography from '@mui/joy/Typography';
import Sheet from '@mui/joy/Sheet';
import SimCardDownloadIcon from '@mui/icons-material/SimCardDownload';
import SearchIcon from '@mui/icons-material/Search';
import LocalFireDepartmentIcon from '@mui/icons-material/LocalFireDepartment';
import AppsIcon from '@mui/icons-material/Apps';
import FolderIcon from '@mui/icons-material/Folder';
import CloseIcon from '@mui/icons-material/Close';
import ZoomInMapIcon from '@mui/icons-material/ZoomInMap';
import ZoomOutMapIcon from '@mui/icons-material/ZoomOutMap';

import { invoke } from "@tauri-apps/api/tauri";
import { appWindow } from '@tauri-apps/api/window';

export default function Sidebar(props: any) {
  const [maximized, setMaximized] = React.useState(false);
  const [menuOption, setMenuOption] = React.useState(0);
  const [diskUsage, setDiskUsage] = React.useState('0');

  React.useEffect(() => {
    invoke('get_disk_usage').then((diskUsage) => {
      setDiskUsage(diskUsage as string);
    });
  }, []);

  function changeMenuOption(option: number) {
    setMenuOption(option);
    props.menuOption(option);
  }

  return (
    <Sheet
      data-tauri-drag-region
      sx={{
        maxWidth: 250,
        p: 1.5,
        flexShrink: 0,
        display: 'flex',
        flexDirection: 'column',
        gap: 2,
        borderRight: '1px solid',
        borderColor: 'divider',
      }}
    >
      <Box sx={{ display: 'flex', gap: 1, alignItems: 'center' }}>
        <IconButton variant="soft" color="neutral">
          <SimCardDownloadIcon />
        </IconButton>
        <Typography fontWeight="xl">Mack App Installer</Typography>
      </Box>
      <Input startDecorator={<SearchIcon />} placeholder="Search" onKeyDown={(e) => {
        if (e.key === 'Enter') {
          props.search(e.currentTarget.value);
        } else if (e.key === 'Escape') {
          e.currentTarget.value = '';
          props.search('');
        }
      }} />
      <Box
        sx={{
          minHeight: 0,
          overflow: 'hidden auto',
          flexGrow: 1,
          display: 'flex',
          flexDirection: 'column',
        }}
      >
        <List
          sx={{
            '--ListItem-radius': '8px',
            '--List-gap': '4px',
            '--List-nestedInsetStart': '40px',
          }}
        >
          {/*<ListItem>
            <ListItemButton selected={menuOption === 0} variant={menuOption === 0 ? 'soft' : 'plain'} color="neutral" onClick={() => changeMenuOption(0)}>
              <ListItemDecorator>
                <LocalFireDepartmentIcon />
              </ListItemDecorator>
              <ListItemContent>Must have</ListItemContent>
            </ListItemButton>
        </ListItem>*/}
          <ListItem>
            <ListItemButton selected={menuOption === 0} variant={menuOption === 0 ? 'soft' : 'plain'} color="neutral" onClick={() => changeMenuOption(0)}>
              <ListItemDecorator>
                <AppsIcon />
              </ListItemDecorator>
              <ListItemContent>All apps</ListItemContent>
            </ListItemButton>
          </ListItem>
          <ListItem>
            <ListItemButton selected={menuOption === 1} variant={menuOption === 1 ? 'soft' : 'plain'} color="neutral" onClick={() => changeMenuOption(1)}>
              <ListItemDecorator>
                <FolderIcon />
              </ListItemDecorator>
              <ListItemContent>Installed Apps</ListItemContent>
            </ListItemButton>
          </ListItem>
        </List>
        <Card
          variant="soft"
          color={parseFloat(diskUsage) > 80 ? 'danger' : 'neutral'}
          invertedColors
          sx={{ boxShadow: 'none' }}
        >
          <Typography fontSize="sm" fontWeight="lg" mb={0.5}>Used space</Typography>
          <Typography level="body3">You are using {diskUsage}% of your available space. Need more?</Typography>
          <LinearProgress value={parseFloat(diskUsage)} determinate sx={{ my: 1.5 }} />
          <Box sx={{ display: 'flex', gap: 2 }}>
            <Link fontSize="sm" component="button" color="danger" onClick={() => changeMenuOption(1)}>Uninstall Apps</Link>
          </Box>
        </Card>
      </Box>
      <Divider />
      <Box data-tauri-drag-region sx={{ display: 'flex', gap: 1, alignItems: 'center' }}>
        <IconButton variant="plain" color="success" onClick={async () => {
          if (maximized) {
            await appWindow.unmaximize();
            setMaximized(false);
          } else {
            await appWindow.maximize();
            setMaximized(true);
          }
        }}>
          <ZoomOutMapIcon />
        </IconButton>
        <IconButton variant="plain" color="warning" onClick={() => appWindow.minimize()}>
          <ZoomInMapIcon />
        </IconButton>
        <IconButton variant="plain" color="danger" onClick={() => appWindow.close()}>
          <CloseIcon />
        </IconButton>
      </Box>
    </Sheet>
  );
}