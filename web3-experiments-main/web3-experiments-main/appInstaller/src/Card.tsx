import * as React from 'react';
import AspectRatio from '@mui/joy/AspectRatio';
import Button from '@mui/joy/Button';
import Card from '@mui/joy/Card';
import CardContent from '@mui/joy/CardContent';
import IconButton from '@mui/joy/IconButton';
import Typography from '@mui/joy/Typography';
import Chip from '@mui/joy/Chip';
import CloudDownloadIcon from '@mui/icons-material/CloudDownload';
import './Card.css';

export default function AppCard(app: any) {
    return (
        <Card variant="outlined" style={{ maxHeight: '380px' }}>
        <div className="first-div">
            <IconButton
            aria-label="bookmark Bahamas Islands"
            variant="plain"
            color="neutral"
            size="sm"
            sx={{ position: 'absolute', top: '0.5rem', left: '0.5rem' }}
            >
                <img src={app.info.icon} style={{ width: '1.4rem', height: '1.4rem' }} />
            </IconButton>
            <Typography level="h2" fontSize="md" sx={{ mb: 0.5, marginLeft: '1.7rem' }}>{app.info.name}</Typography>
            <Typography level="body2">{app.info.description}</Typography>
        </div>
        <AspectRatio minHeight="120px" maxHeight="200px">
            <img
            src={app.info.images[0]}
            loading="lazy"
            alt=""
            />
        </AspectRatio>
        <CardContent orientation="horizontal">
            <div>
            <Typography level="body3">Tags:</Typography>
            {app.info.tags.map((tag: string) => (
                <Chip size="sm" variant="soft" color="neutral" sx={{ mr: 0.5, mb: 0.5 }} key={tag}>{tag}</Chip>
            ))}
            </div>
            <Button
            variant="outlined"
            color="neutral"
            startDecorator={<CloudDownloadIcon />}
            sx={{ ml: 'auto', fontWeight: 600 }}
            >
            Download
            </Button>
        </CardContent>
        </Card>
    );
}