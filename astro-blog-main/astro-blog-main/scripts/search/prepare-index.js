import path from 'path'
import { promises as fs } from 'fs'
import { globby } from 'globby'
import grayMatter from 'gray-matter'

(async function () {
    // prepare the dirs
    const srcDir = path.join(process.cwd(), 'src')
    const publicDir = path.join(process.cwd(), 'public')
    const contentBlogDir = path.join(srcDir, 'content', 'blog')
    const contentFilePatterns = ['md', 'mdx', 'mdoc'].map(ext => `**/*.${ext}`)
    const indexFile = path.join(publicDir, 'search-index.json')
    const getSlugFromPathname = (pathname) => path.basename(pathname, path.extname(pathname))

    const contentFilePaths = await globby(contentFilePatterns, { cwd: contentBlogDir })

    if(contentFilePaths.length) {
        const index = await Promise.all(contentFilePaths.map(async (pathname) => {
            const content = await fs.readFile(path.join(contentBlogDir, pathname), 'utf8')
            const { data } = grayMatter(content)
            const slug = getSlugFromPathname(pathname)
            return { ...data, slug }
        }))
        await fs.writeFile(indexFile, JSON.stringify(index))
        console.log(`Indexed ${index.length} documents from ${contentBlogDir} to ${indexFile}`)
    } else {
        console.log(`No documents found in ${contentBlogDir}`)
    }
})();