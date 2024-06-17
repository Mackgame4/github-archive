import {
  Document,
  View,
  Text,
  Image,
  Link,
  Page,
  StyleSheet,
} from '@react-pdf/renderer';

import { colorVars, ln, getLocale } from './Utils';
import { Config } from './Config';

import DocHeader from './components/docHeader';

import PdfIcon from './components/pdfIcons';
import PdfProgBar from './components/pdfProgBar';

const styles = StyleSheet.create({
  body: {
    padding: 5,
    paddingHorizontal: 45,
    backgroundColor: colorVars.backgroudColor,
  },
  content: {
    flex: 1,
    flexDirection: 'row',
    paddingHorizontal: 15
  },
  leftContainer: {
    width: '55%',
    alignItems: 'flex-start',
  },
  rightContainer: {
    width: '45%',
    alignItems: 'flex-end',
  },
  title: {
    fontSize: 18,
    fontFamily: 'JetBrainsMono-Bold',
    fontWeight: 'bold',
    color: colorVars.primaryColor,
    letterSpacing: 2,
  },
  text: {
    fontSize: 10,
    fontFamily: 'JetBrainsMono-Regular',
    color: colorVars.textColor,
    letterSpacing: 1,
    textDecoration: 'none',
  },
  link: {
    fontSize: 10,
    fontFamily: 'JetBrainsMono-Regular',
    color: colorVars.textColor,
    letterSpacing: 1,
    textDecoration: 'underline',
  },
  skillText: {
    fontSize: 10,
    fontFamily: 'JetBrainsMono-Regular',
    color: colorVars.textColor,
    letterSpacing: 0.5,
    textDecoration: 'none',
    marginTop: 5
  },
  progbarText: {
    fontSize: 9,
    fontFamily: 'JetBrainsMono-Regular',
    color: colorVars.textColor,
    letterSpacing: 0.5,
    textDecoration: 'none',
    marginTop: 5
  },
  footerText: {
    fontSize: 8,
    fontFamily: 'JetBrainsMono-Regular',
    color: colorVars.accentColor,
    letterSpacing: 1,
    textDecoration: 'none'
  }
});

const Doc = () => (
  <Document>
    <Page size="A4" orientation="portrait" style={styles.body}>
      <DocHeader />
      <View style={styles.content}>
        <View style={styles.leftContainer}>
          {/** Summarize Section */}
          <Text style={styles.text}>{ln('hello')} {Config.firstName}{Config.userName ? ` (${Config.userName}) ` : ' '}{Config.lastName}. {getLocale().summarize}</Text>
          {/** WorkExperience Section */}
          <Text style={[styles.title, { marginTop: 20 }]}>{ln('experienceText')}</Text>
          {getLocale().experience.map((job, index) => (
            <View key={index} style={{ marginTop: 5, textAlign: 'left', alignItems: 'flex-start' }}>
              <Link src={job.src} style={{ textDecoration: 'none' }}>
                <Text style={styles.footerText}>{job.date}</Text>
                {!job.date ? <View style={{ marginTop: 7 }} /> : null}
                <Text style={styles.text}>{job.title}</Text>
                <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                  {job.company ? <>
                  <Text style={styles.footerText}>{job.company} - {job.location}</Text>
                  <PdfIcon height={7} name="externalLinkIcon" color={colorVars.primaryColor} isOutlined />
                  </> : null}
                </View>
              </Link>
              {job.description ?
              <Text style={[styles.footerText, { marginTop: 10 }]}>{job.description}</Text>
              : null}
            </View>
          ))}
          {/** Education Section */}
          <Text style={[styles.title, { marginTop: 20 }]}>{ln('educationText')}</Text>
          {getLocale().education.map((edu, index) => (
            <View key={index} style={{ marginTop: 5, textAlign: 'left', alignItems: 'flex-start' }}>
              <Link src={edu.src} style={{ textDecoration: 'none' }}>
                <Text style={styles.footerText}>{edu.date}</Text>
                <Text style={styles.text}>{edu.title}</Text>
                <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                  <Text style={styles.footerText}>{edu.institution} - {edu.location}</Text>
                  <PdfIcon height={7} name="externalLinkIcon" color={colorVars.primaryColor} isOutlined />
                </View>
              </Link>
              {edu.description &&
              <Text style={[styles.footerText, { marginTop: 10 }]}>{edu.description}</Text>
              }
            </View>
          ))}
        </View>
        <View style={styles.rightContainer}>
          {/** Contacts Section */}
          <Text style={styles.title}>{ln('contacts')}</Text>
          <View style={{ flexDirection: 'row', alignItems: 'center', marginTop: 5 }}>
            <PdfIcon height={12} name="phoneIcon" color={colorVars.primaryColor} isOutlined />
            <Link style={[styles.link, { marginLeft: 5, letterSpacing: 0.5 }]}
              src={`tel:${Config.phoneNumber}`}
            >{Config.phoneNumber}</Link>
          </View>
          <View style={{ flexDirection: 'row', alignItems: 'center', marginTop: 2 }}>
            <PdfIcon height={12} name="emailIcon" color={colorVars.primaryColor} isOutlined />
            <Link style={[styles.link, { marginLeft: 5, letterSpacing: 0.5 }]}
              src={`mailto:${Config.email}`}
            >{Config.email}</Link>
          </View>
          <View style={{ flexDirection: 'row', alignItems: 'center', marginTop: 2 }}>
            <PdfIcon height={12} name="githubIcon" color={colorVars.primaryColor} isOutlined />
            <Link style={[styles.link, { marginLeft: 5 }]} src={Config.githuLink}>@{Config.githubUsername}</Link>
          </View>
          <View style={{ flexDirection: 'row', alignItems: 'center', marginTop: 2 }}>
            <PdfIcon height={12} name="linkedInIcon" color={colorVars.primaryColor} isOutlined />
            <Link style={[styles.link, { marginLeft: 5 }]} src={Config.linkedInLink}>@{Config.linkedInUsername}</Link>
          </View>
          {/** Skills Section */}
          <Text style={[styles.title, { marginTop: 20 }]}>{ln('skillsText')}</Text>
          {getLocale().skills.map((skill, index) => (
            <Text key={index} style={styles.skillText}>{skill}</Text>
          ))}
          {/** Tools Section */}
          <Text style={[styles.title, { marginTop: 20 }]}>{ln('toolsText')}</Text>
          {Config.tools.map((tool, index) => (
            <View key={index} style={{ textAlign: 'right', alignItems: 'flex-end' }}>
              <Text style={styles.progbarText}>{tool.name}</Text>
              <PdfProgBar value={tool.level} width={150} height={4} isOutlined isRounded={false} />
            </View>
          ))}
          {/** Languages Section */}
          <Text style={[styles.title, { marginTop: 20 }]}>{ln('languagesText')}</Text>
          {getLocale().languages.map((lang, index) => (
            <View key={index} style={{ marginTop: 5, textAlign: 'right', alignItems: 'flex-end' }}>
              <Text style={styles.text}>{lang.name}</Text>
              <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                <Image src={lang.flag} style={{ width: 'auto', height: 8, marginRight: 7 }} />
                <Text style={styles.footerText}>- {lang.level}</Text>
              </View>
            </View>
          ))}
        </View>
      </View>
    </Page>
  </Document>
);

export default Doc;